terraform import azurerm_network_interface.nic_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"


terraform import azurerm_managed_disk.osdisk_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"

terraform import azurerm_windows_virtual_machine.vm_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILD­CONTROLLER-test"



====================

resource "azurerm_network_interface" "nic_buildcontroller" {
  name                = "nic-BUILDCONTROLLER-00-test"
  location            = var.location_name
  resource_group_name = var.rg_name

  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = null
    name                                               = "nic-BUILDCONTROLLER-00-test-ipConfig"
    primary                                            = true
    private_ip_address                                 = "10.210.0.19"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = null
    subnet_id                                          = azurerm_subnet.internal.id
  }
}
-------------------------

resource "azurerm_managed_disk" "osdisk_buildcontroller" {
  name                 = "BUILDCONTROLLER-OSdisk-00-test"
  location             = var.location_name
  resource_group_name  = var.rg_name
  storage_account_type = "Premium_LRS"
  disk_size_gb         = 100
  create_option        = "Restore"
  hyper_v_generation   = "V1"
  os_type              = "Windows"

  lifecycle {
    ignore_changes = [
      hyper_v_generation,
      source_resource_id,
      trusted_launch_enabled,
    ]

  }
}


---------------------------

# Creating VMs

resource "azurerm_virtual_machine" "vm_buildcontroller" {
  name                  = "BUILDCONTROLLER-test"
  location              = var.location_name
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic_buildcontroller.id]
  vm_size               = "Standard_D2as_v5"

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
  }

  identity {
    type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "BUILDCONTROLLER-OSdisk-00-test"
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_id   = azurerm_managed_disk.osdisk_buildcontroller.id
    managed_disk_type = "Premium_LRS"
    os_type           = "Windows"
    disk_size_gb      = 100
  }

  lifecycle {
    ignore_changes = [
      boot_diagnostics,
      identity,
      storage_os_disk,
    ]
  }
}

#### =======================#####


nics.tf

resource "azurerm_network_interface" "nic" {
  for_each            = var.nics
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${each.value.name}-ipConfig"
    primary                       = true
    private_ip_address_allocation = each.value.allocation               # "Dynamic" or "Static"
    private_ip_address            = each.value.allocation == "Static" ? each.value.private_ip : null
    private_ip_address_version    = "IPv4"
    subnet_id                     = each.value.subnet_id
    # public_ip_address_id, gateway_load_balancer_frontend_ip_configuration_id intentionally omitted
  }
}

--------------------

# OS DISKS (imported) — keep read-only to avoid accidental replacement
resource "azurerm_managed_disk" "os" {
  for_each            = var.os_disks
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name

  # We’re tracking existing OS disks; don’t mutate them
  lifecycle {
    ignore_changes = all
  }
}

# DATA DISKS (optional, only if you populate var.data_disks)
resource "azurerm_managed_disk" "data" {
  for_each            = local.data_disks_map
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name
  storage_account_type = each.value.sku

  lifecycle {
    ignore_changes = all
  }
}

# Attach DATA DISKS to their VMs
resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  for_each           = local.data_disks_map
  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = azurerm_virtual_machine.vm[each.value.vm_key].id
  lun                = each.value.lun
  caching            = each.value.caching
}

-----------------------

# Use legacy resource to support existing VMs booting from attached OS disks
resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vms
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  vm_size               = each.value.size
  network_interface_ids = [ azurerm_network_interface.nic[each.value.nic_key].id ]

  # Match your working config: storage_uri (not storage_account_uri)
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

  storage_os_disk {
    name              = var.os_disks[each.value.os_disk_key].name
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_id   = azurerm_managed_disk.os[each.value.os_disk_key].id
    managed_disk_type = var.os_disks[each.value.os_disk_key].storage_account_type != "" ? var.os_disks[each.value.os_disk_key].storage_account_type : null
    os_type           = var.os_disks[each.value.os_disk_key].os_type != "" ? var.os_disks[each.value.os_disk_key].os_type : null
    disk_size_gb      = var.os_disks[each.value.os_disk_key].disk_size_gb != 0 ? var.os_disks[each.value.os_disk_key].disk_size_gb : null
  }

  lifecycle {
    ignore_changes = [
      boot_diagnostics,
      identity,
      storage_os_disk,
    ]
  }
}



======================================


# OS disk: old -> new
terraform state mv \
  azurerm_managed_disk.osdisk_buildcontroller \
  'azurerm_managed_disk.os["buildcontroller_test"]'

# NIC: old -> new
terraform state mv \
  azurerm_network_interface.nic_buildcontroller \
  'azurerm_network_interface.nic["buildcontroller_test"]'

# VM: old -> new
terraform state mv \
  azurerm_virtual_machine.vm_buildcontroller \
  'azurerm_virtual_machine.vm["buildcontroller_test"]'







<img width="705" height="250" alt="{0A58A2A4-C8E3-483E-98D0-07BC1877EC19}" src="https://github.com/user-attachments/assets/a2e4007e-623c-4af0-b7c2-186414d6ab2d" />













