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


================================================================

NIC Block

terraform import 'azurerm_network_interface.nic[""]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test

DISK BLock

terraform import 'azurerm_managed_disk.os[""]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test

VM Block

terraform import 'azurerm_virtual_machine.vm[""]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILDCONTROLLER-test











-=-=--=---=-=-=-=-==-=-=--




terraform.tfvars

#Resource Group Variales
rg_name       = "mr8-dev-rg"
location_name = "South Central US"

# TAGS!
global_tags = {
  "environment" = "Development"
  "domain"      = "Keais"
  "owner"       = "Greg Johnson"
  "managed by"  = "terraform"

}


# main V-net Variables
main_vnet_name          = "mr8-dev-scus-vnet"
main_vnet_address_space = ["10.239.64.0/22"]
main_dns_servers        = ["10.249.8.4", "10.249.8.5"]

# Main Subnet Variables
internal_snet_name           = "mr8-dev-scus-internal-snet"
internal_snet_address_prefix = "10.239.64.0/24"
wvd_snet_name                = "mr8-dev-scus-WVD-snet"
wvd_snet_address_prefix      = "10.239.66.0/26"
dmz_snet_name                = "mr8-dev-scus-dmz-snet"
dmz_snet_address_prefix      = "10.239.65.0/24"
bot_wvd_snet_name            = "mr8-dev-bot-scus-WVD-snet"
bot_wvd_snet_address_prefix  = "10.239.66.64/26"

# Main NSG Variables
nsg_internal_name = "mr8-dev-scus-internal-nsg"
nsg_wvd_name      = "mr8-dev-scus-wvd-nsg"
nsg_dmz_name      = "mr8-dev-scus-dmz-nsg"
nsg_bot_wvd_name  = "mr8-dev-bot-scus-WVD-nsg"

# Temp V-net Variables
temp_vnet_name          = "temp-dev-vnet-01"
temp_vnet_address_space = ["10.210.0.0/16"]
temp_dns_servers        = []

# Temp Subnet Variables
Internal_snet_name           = "Internal"
Internal_snet_address_prefix = "10.210.0.0/24"

# Temp NSG Variables
nsg_Internal_name = "temp-dev-vnet-01-NSG"


# Nics
nics = {
  "buildcontroller_test" = {
    name       = "nic-BUILDCONTROLLER-00-test"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal"
    allocation = "Dynamic"
    private_ip = "10.210.0.19"
  },
  "dev_mr8_test" = {
    name       = "nic-DEV-MR8-00-test"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal"
    allocation = "Dynamic"
    private_ip = "10.210.0.11"
  },
  "dev_mrfile_test" = {
    name       = "nic-DEV-MRFILE-00-test"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal"
    allocation = "Dynamic"
    private_ip = "10.210.0.16"
  },
  "dev_web_2012r2_test" = {
    name       = "nic-DEV-WEB-2012r2-00-test"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal"
    allocation = "Dynamic"
    private_ip = "10.210.0.18"
  },
  "dockerbuild_test" = {
    name       = "nic-DOCKERBUILD-00-test"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal"
    allocation = "Dynamic"
    private_ip = "10.210.0.9"
  }
  "dvkib2_9" = {
    name       = "dvkib2-9-nic"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation = "Dynamic"
    private_ip = "10.239.64.4"
  },
  "dvkib2_app01" = {
    name       = "dvkib2-app01435"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation = "Dynamic"
    private_ip = "10.239.64.6"
  }
  "dvkib2_def01" = {
    name       = "dvkib2-def01508"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation = "Dynamic"
    private_ip = "10.239.64.60"
  }
  "dvkib2_rpa01" = {
    name       = "dvkib2-rpa01497"
    subnet_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation = "Dynamic"
    private_ip = "10.239.64.7"
  }

}

# Disks

os_disks = {
  "buildcontroller_test" = {
    name                 = "BUILDCONTROLLER-OSdisk-00-test"
    disk_size_gb         = 100
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dev_mr8_test" = {
    name                 = "DEV-MR8-OSdisk-00-test"
    disk_size_gb         = 80
    storage_account_type = "StandardSSD_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dev_mrfile_test" = {
    name                 = "DEV-MRFILE-OSdisk-00-test"
    disk_size_gb         = 40
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dev_web_2012r2_test" = {
    name                 = "DEV-WEB-2012r2-OSdisk-00-test"
    disk_size_gb         = 120
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dockerbuild_test" = {
    name                 = "DOCKERBUILD-OSdisk-00-test"
    disk_size_gb         = 236
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dvkib2_9" = {
    name                 = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
    disk_size_gb         = 256
    storage_account_type = "Standard_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },
  "dvkib2_app01" = {
    name                 = "DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  }
  "dvkib2_def01" = {
    name                 = "DVKIB2-DEF01_osdisk1"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  }
  "dvkib2_rpa01" = {
    name                 = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  }

}

# Vms

vms = {
  "buildcontroller_test" = {
    name          = "BUILDCONTROLLER-test"
    size          = "Standard_D2as_v5"
    nic_key       = "buildcontroller_test"
    os_disk_key   = "buildcontroller_test"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },

  "dev_mr8_test" = {
    name          = "DEV-MR8-test"
    size          = "Standard_F4s_v2"
    nic_key       = "dev_mr8_test"
    os_disk_key   = "dev_mr8_test"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dev_mrfile_test" = {
    name          = "DEV-MRFILE-test"
    size          = "Standard_B1s"
    nic_key       = "dev_mrfile_test"
    os_disk_key   = "dev_mrfile_test"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dev_web_2012r2_test" = {
    name          = "DEV-WEB-2012r2-test"
    size          = "Standard_B4as_v2"
    nic_key       = "dev_web_2012r2_test"
    os_disk_key   = "dev_web_2012r2_test"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dockerbuild_test" = {
    name          = "DOCKERBUILD-test"
    size          = "Standard_D4s_v3"
    nic_key       = "dockerbuild_test"
    os_disk_key   = "dockerbuild_test"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dvkib2_9" = {
    name          = "dvkib2-9"
    size          = "Standard_D4as_v5"
    nic_key       = "dvkib2_9"
    os_disk_key   = "dvkib2_9"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dvkib2_app01" = {
    name          = "DVKIB2-APP01"
    size          = "Standard_D2s_v4"
    nic_key       = "dvkib2_app01"
    os_disk_key   = "dvkib2_app01"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dvkib2_def01" = {
    name          = "DVKIB2-DEF01"
    size          = "Standard_B2s"
    nic_key       = "dvkib2_def01"
    os_disk_key   = "dvkib2_def01"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  },
  "dvkib2_rpa01" = {
    name          = "DVKIB2-RPA01"
    size          = "Standard_B8s_v2"
    nic_key       = "dvkib2_rpa01"
    os_disk_key   = "dvkib2_rpa01"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  }
}

NICS.tf

resource "azurerm_network_interface" "nic" {
  for_each            = var.nics
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${each.value.name}-ipConfig"
    primary                       = true
    private_ip_address_allocation = each.value.allocation # "Dynamic" or "Static"
    private_ip_address            = each.value.allocation == "Static" ? each.value.private_ip : null
    private_ip_address_version    = "IPv4"
    subnet_id                     = each.value.subnet_id
  }
}


# vms.tf


resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vms
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  vm_size               = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]

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


disks.tf

# OS DISKS (imported) 
resource "azurerm_managed_disk" "os" {
  for_each            = var.os_disks
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name

  storage_account_type = each.value.storage_account_type
  create_option        = "Restore"
  disk_size_gb         = each.value.disk_size_gb
  os_type              = each.value.os_type
  hyper_v_generation   = each.value.hyper_v_generation

  # We’re tracking existing OS disks; don’t mutate them
  lifecycle {
    ignore_changes = all
  }
}

   


========================================================================





  dynamic "storage_data_disk" {
    for_each = lookup(var.data_disks, each.key, [])
    content {
      name                 = storage_data_disk.value.name
      lun                  = storage_data_disk.value.lun
      disk_size_gb         = storage_data_disk.value.disk_size_gb
      managed_disk_type    = storage_data_disk.value.storage_account_type
      caching              = storage_data_disk.value.caching
      create_option        = "Attach"
      managed_disk_id      = azurerm_managed_disk.data[storage_data_disk.value.name].id
    }
  }














