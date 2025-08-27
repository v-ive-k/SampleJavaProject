# Only VMs where you're attaching an existing OS disk
resource "azurerm_virtual_machine" "vm_migrated" {
  for_each              = { for k, v in var.vms : k => v if v.os_disk_creation_option == "Attach" }
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  vm_size               = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
  tags                  = var.global_tags

  storage_os_disk {
    name              = var.os_disks[each.value.os_disk_key].name
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_id   = coalesce(lookup(each.value, "managed_disk_id", null), azurerm_managed_disk.os[each.value.os_disk_key].id)
    managed_disk_type = var.os_disks[each.value.os_disk_key].storage_account_type
    os_type           = var.os_disks[each.value.os_disk_key].os_type
    disk_size_gb      = var.os_disks[each.value.os_disk_key].disk_size_gb
  }

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


===================================




resource "azurerm_windows_virtual_machine" "vm_new_win" {
  for_each              = { for k, v in var.vms : k => v if v.os_disk_creation_option == "FromImage" && try(v.windows_config != null, false) }
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  size                  = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
  admin_username        = each.value.os_profiles.admin_username
  admin_password        = lookup(each.value.os_profiles, "admin_password", null)
  source_image_id       = lookup(each.value.image_reference, "id", null)

  dynamic "os_disk" {
    for_each = [1]
    content {
      caching              = "ReadWrite"
      storage_account_type = var.os_disks[each.value.os_disk_key].storage_account_type
      name                 = "${each.value.name}-OsDisk"
    }
  }

  dynamic "additional_unattend_content" {
    for_each = []
    content {}
  }

  dynamic "data_disk" {
    for_each = lookup(var.data_disks, each.key, [])
    content {
      lun                = data_disk.value.lun
      caching            = data_disk.value.caching
      disk_size_gb       = data_disk.value.disk_size_gb
      storage_account_type = data_disk.value.storage_account_type
      create_option      = "Empty"
    }
  }

  patch_mode = "AutomaticByOS"
  provision_vm_agent = each.value.windows_config.provision_vm_agent
  enable_automatic_updates = each.value.windows_config.enable_automatic_upgrades
  tags = var.global_tags
}
