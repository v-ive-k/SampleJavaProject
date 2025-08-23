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




 # azurerm_virtual_machine.vm["dvkib2_9"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-9" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "dvkib2-9"
      - tags                             = {
          - "Domain"             = "Keaisinc"
          - "Owner"              = "Greg Johnson"
          - "cm-resource-parent" = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.DesktopVirtualization/hostpools/MR8WVD-Dev-Automation-Bot-02"
          - "environment"        = "Development"
          - "name"               = "Keaisinc"
        } -> null
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - additional_capabilities {}

      ~ boot_diagnostics {
          + storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
            # (1 unchanged attribute hidden)
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_image_reference (known after apply)
      - storage_image_reference {
          - id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1" -> null
            # (4 unchanged attributes hidden)
        }

      ~ storage_os_disk {
          ~ create_option             = "FromImage" -> "Attach"
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"        
          ~ managed_disk_type         = "StandardSSD_LRS" -> "Standard_LRS"
            name                      = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
            # (6 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_app01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-APP01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-APP01"
      - tags                             = {
          - "environment" = "development"
        } -> null
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      ~ boot_diagnostics {
          + storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
            # (1 unchanged attribute hidden)
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_image_reference (known after apply)
      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-Datacenter" -> null
          - version   = "latest" -> null
        }

      ~ storage_os_disk {
          ~ create_option             = "FromImage" -> "Attach"
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b"
            name                      = "DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b"
            # (7 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_def01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-DEF01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-DEF01"
      - tags                             = {
          - "domain"      = "keaisinc"
          - "environment" = "development"
          - "owner"       = "Jaspinder Singh"
        } -> null
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      ~ boot_diagnostics {
          + storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
            # (1 unchanged attribute hidden)
        }

      ~ identity {
          - identity_ids = [] -> null
          ~ principal_id = "fab5ba7d-6e4d-49b5-b182-c6ecb54b7ae6" -> (known after apply)
          ~ tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> (known after apply)
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_image_reference (known after apply)
      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-datacenter-gensecond" -> null
          - version   = "latest" -> null
        }

      ~ storage_os_disk {
          ~ create_option             = "FromImage" -> "Attach"
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-DEF01_osdisk1" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-DEF01_osdisk1"
            name                      = "DVKIB2-DEF01_osdisk1"
            # (7 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-RPA01"
      - tags                             = {
          - "Business Unit" = "Keais"
          - "domain"        = "keaisinc"
          - "environment"   = "development"
          - "owner"         = "Greg Johnson"
        } -> null
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      ~ boot_diagnostics {
          + storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
            # (1 unchanged attribute hidden)
        }

      ~ identity {
          - identity_ids = [] -> null
          ~ principal_id = "63cc7c8d-966f-4519-b446-b6b8dc644d3b" -> (known after apply)
          ~ tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> (known after apply)
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)
      - storage_data_disk {
          - caching                   = "ReadOnly" -> null
          - create_option             = "Attach" -> null
          - disk_size_gb              = 512 -> null
          - lun                       = 0 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/dvkib2-rpa01_datadisk01" -> null     
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-RPA01_DataDisk01" -> null
          - write_accelerator_enabled = false -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_image_reference (known after apply)
      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-datacenter-gensecond" -> null
          - version   = "latest" -> null
        }

      ~ storage_os_disk {
          ~ create_option             = "FromImage" -> "Attach"
            name                      = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
            # (8 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_network.main_vnet will be updated in-place
  ~ resource "azurerm_virtual_network" "main_vnet" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet"        
        name                           = "mr8-dev-scus-vnet"
      ~ tags                           = {
          + "domain"      = "Keais"
            "environment" = "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (10 unchanged attributes hidden)
    }

  # azurerm_virtual_network.temp_vnet will be updated in-place
  ~ resource "azurerm_virtual_network" "temp_vnet" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01"
        name                           = "temp-dev-vnet-01"
      ~ tags                           = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (10 unchanged attributes hidden)


































