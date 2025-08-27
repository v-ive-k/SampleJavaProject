#############################################
# IMPORTED/EXISTING VMs (legacy VM resource)
# Keep the resource name "vm" to match state
#############################################
resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vms
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  vm_size               = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
  tags                  = var.global_tags

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diag_uri != "" ? [1] : []
    content {
      enabled     = true
      storage_uri = each.value.boot_diag_uri
    }
  }

  dynamic "identity" {
    for_each = each.value.identity_type != "" ? [1] : []
    content {
      type = each.value.identity_type
    }
  }

  # OS disk: Attach or FromImage
  storage_os_disk {
    name              = var.os_disks[each.value.os_disk_key].name
    caching           = "ReadWrite"
    create_option     = each.value.os_disk_creation_option
    managed_disk_id   = each.value.os_disk_creation_option == "Attach"
                        ? coalesce(lookup(each.value, "managed_disk_id", null), azurerm_managed_disk.os[each.value.os_disk_key].id)
                        : null
    managed_disk_type = var.os_disks[each.value.os_disk_key].storage_account_type
    os_type           = var.os_disks[each.value.os_disk_key].os_type
    disk_size_gb      = var.os_disks[each.value.os_disk_key].disk_size_gb
  }

  # Image fields only when FromImage
  dynamic "storage_image_reference" {
    for_each = each.value.os_disk_creation_option == "FromImage" ? [1] : []
    content {
      id        = lookup(each.value.image_reference, "id", null)
      publisher = lookup(each.value.image_reference, "publisher", null)
      offer     = lookup(each.value.image_reference, "offer", null)
      sku       = lookup(each.value.image_reference, "sku", null)
      version   = lookup(each.value.image_reference, "version", null)
    }
  }

  dynamic "os_profile" {
    for_each = try(each.value.os_profiles, null) != null ? [each.value.os_profiles] : []
    content {
      computer_name  = lookup(os_profile.value, "computer_name", null)
      admin_username = os_profile.value.admin_username
      admin_password = lookup(os_profile.value, "admin_password", null)
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = try(each.value.windows_config, null) != null ? [each.value.windows_config] : []
    content {
      provision_vm_agent        = os_profile_windows_config.value.provision_vm_agent
      enable_automatic_upgrades = os_profile_windows_config.value.enable_automatic_upgrades
    }
  }

  # DATA disks attach (legacy VM supports inline)
  dynamic "storage_data_disk" {
    for_each = lookup(var.data_disks, each.key, [])
    content {
      name              = storage_data_disk.value.name
      lun               = storage_data_disk.value.lun
      disk_size_gb      = storage_data_disk.value.disk_size_gb
      managed_disk_type = storage_data_disk.value.storage_account_type
      caching           = storage_data_disk.value.caching
      create_option     = "Attach"
      managed_disk_id   = azurerm_managed_disk.data["${each.key}-${storage_data_disk.value.lun}"].id
    }
  }

  lifecycle {
    ignore_changes = [
      boot_diagnostics,
      primary_network_interface_id,
      os_profile,
      os_profile_windows_config,
    ]
  }
}

#############################################
# NEW WINDOWS VMs (gated; separate map)
#############################################
resource "azurerm_windows_virtual_machine" "vm_new_win" {
  for_each = var.enable_new_vms ? var.new_vms : {}

  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  size                  = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
  admin_username        = each.value.os_profiles.admin_username
  admin_password        = each.value.os_profiles.admin_password
  tags                  = var.global_tags

  # Choose one: image by ID or by reference fields
  source_image_id = lookup(each.value.image_reference, "id", null)

  os_disk {
    name                 = "${each.value.name}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disks[each.value.os_disk_key].storage_account_type
  }

  provision_vm_agent       = each.value.windows_config.provision_vm_agent
  enable_automatic_updates = each.value.windows_config.enable_automatic_upgrades
}

# Helper: map all data disks, then attach only for NEW VMs
locals {
  new_vm_keys = toset(keys(var.new_vms))
  data_disk_pairs = {
    for pair in flatten([
      for vm_key, disks in var.data_disks : [
        for d in disks : {
          map_key = "${vm_key}-${d.lun}"
          vm_key  = vm_key
          disk    = d
        }
      ]
    ]) : pair.map_key => pair
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "win_attach" {
  for_each = {
    for k, v in local.data_disk_pairs : k => v
    if contains(local.new_vm_keys, v.vm_key)
  }

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_new_win[each.value.vm_key].id
  lun                = each.value.disk.lun
  caching            = each.value.disk.caching
  create_option      = "Attach"
}

=======================

############################
# OS DISKS (only for Attach)
############################
resource "azurerm_managed_disk" "os" {
  for_each = {
    for k, v in var.os_disks : k => v
    if lookup(var.vms[k], "os_disk_creation_option", "Attach") == "Attach"
  }

  name                 = each.value.name
  location             = var.location_name
  resource_group_name  = var.rg_name
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  os_type              = each.value.os_type
  hyper_v_generation   = each.value.hyper_v_generation

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

############################
# DATA DISKS (define only)
############################
resource "azurerm_managed_disk" "data" {
  for_each = {
    for pair in flatten([
      for vm, disks in var.data_disks : [
        for d in disks : {
          key   = "${vm}-${d.lun}"
          value = d
        }
      ]
    ]) : pair.key => pair.value
  }

  name                 = each.value.name
  location             = var.location_name
  resource_group_name  = var.rg_name
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  create_option        = "Empty"   # never "Attach" here

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}


=========================


# NEW Windows VMs ONLY (to provision greenfield, gated)
variable "new_vms" {
  type = map(object({
    name          = string
    size          = string
    nic_key       = string
    os_disk_key   = string
    image_reference = object({
      id        = optional(string)
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
    })
    os_profiles = object({
      admin_username = string
      admin_password = string
      computer_name  = optional(string)
    })
    windows_config = object({
      provision_vm_agent        = bool
      enable_automatic_upgrades = bool
    })
  }))
  default = {}
}












