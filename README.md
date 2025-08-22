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


az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform plan
azurerm_managed_disk.osdisk_buildcontroller: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test]
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg]
azurerm_network_security_group.nsg_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg]
azurerm_network_interface.nic_buildcontroller: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test]
azurerm_virtual_machine.vm_buildcontroller: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILDCONTROLLER-test]
azurerm_subnet.dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_virtual_network.main_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet]
azurerm_network_security_group.nsg_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg]
azurerm_network_security_group.nsg_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg]
azurerm_network_security_group.nsg_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg]
azurerm_subnet.bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet.wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_subnet_network_security_group_association.assoc_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_subnet_network_security_group_association.assoc_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place
  - destroy
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # azurerm_managed_disk.os["buildcontroller_test"] will be created
  + resource "azurerm_managed_disk" "os" {
      + create_option                     = "Restore"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 100
      + hyper_v_generation                = "V1"
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "BUILDCONTROLLER-OSdisk-00-test"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + os_type                           = "Windows"
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.osdisk_buildcontroller will be destroyed
  # (because azurerm_managed_disk.osdisk_buildcontroller is not in configuration)
  - resource "azurerm_managed_disk" "osdisk_buildcontroller" {
      - create_option                     = "Restore" -> null
      - disk_iops_read_only               = 0 -> null
      - disk_iops_read_write              = 500 -> null
      - disk_mbps_read_only               = 0 -> null
      - disk_mbps_read_write              = 100 -> null
      - disk_size_gb                      = 100 -> null
      - hyper_v_generation                = "V1" -> null
      - id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test" -> null
      - location                          = "southcentralus" -> null
      - max_shares                        = 0 -> null
      - name                              = "BUILDCONTROLLER-OSdisk-00-test" -> null
      - network_access_policy             = "AllowAll" -> null
      - on_demand_bursting_enabled        = false -> null
      - optimized_frequent_attach_enabled = false -> null
      - os_type                           = "Windows" -> null
      - performance_plus_enabled          = false -> null
      - public_network_access_enabled     = true -> null
      - resource_group_name               = "mr8-dev-rg" -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-BUILDCON-BuildCon-6a158948-864b-47cb-841a-0e40f85e7658/bookmark/25ee4005-6918-496e-9206-d5b50b1eb4e8" -> null
      - storage_account_type              = "Premium_LRS" -> null
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      - tier                              = "P10" -> null
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (10 unchanged attributes hidden)
    }

  # azurerm_network_interface.nic["buildcontroller_test"] will be created
  + resource "azurerm_network_interface" "nic" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "nic-BUILDCONTROLLER-00-test"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-dev-rg"
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "nic-BUILDCONTROLLER-00-test-ipConfig"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal"
        }
    }

  # azurerm_network_interface.nic_buildcontroller will be destroyed
  # (because azurerm_network_interface.nic_buildcontroller is not in configuration)
  - resource "azurerm_network_interface" "nic_buildcontroller" {
      - accelerated_networking_enabled = false -> null
      - applied_dns_servers            = [] -> null
      - dns_servers                    = [] -> null
      - id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test" -> null
      - ip_forwarding_enabled          = false -> null
      - location                       = "southcentralus" -> null
      - mac_address                    = "60-45-BD-E2-27-89" -> null
      - name                           = "nic-BUILDCONTROLLER-00-test" -> null
      - private_ip_address             = "10.210.0.19" -> null
      - private_ip_addresses           = [
          - "10.210.0.19",
        ] -> null
      - resource_group_name            = "mr8-dev-rg" -> null
      - tags                           = {} -> null
      - virtual_machine_id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILDCONTROLLER-test" -> null
        # (5 unchanged attributes hidden)

      - ip_configuration {
          - name                                               = "nic-BUILDCONTROLLER-00-test-ipConfig" -> null
          - primary                                            = true -> null
          - private_ip_address                                 = "10.210.0.19" -> null
          - private_ip_address_allocation                      = "Dynamic" -> null
          - private_ip_address_version                         = "IPv4" -> null
          - subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01/subnets/Internal" -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_network_security_group.nsg_bot_wvd will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_bot_wvd" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"
        name                = "mr8-dev-bot-scus-WVD-nsg"
      ~ tags                = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_network_security_group.nsg_dmz will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_dmz" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"  
        name                = "mr8-dev-scus-dmz-nsg"
      ~ tags                = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_network_security_group.nsg_internal will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_internal" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"
        name                = "mr8-dev-scus-internal-nsg"
      ~ tags                = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_network_security_group.nsg_wvd will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_wvd" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"  
        name                = "mr8-dev-scus-wvd-nsg"
      ~ tags                = {
          - "Workload"    = "WVD Dev" -> null
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg"
        name       = "mr8-dev-rg"
      ~ tags       = {
          - "Business Unit" = "Keais" -> null
          + "domain"        = "Keais"
            "environment"   = "Development"
          + "managed by"    = "terraform"
          + "owner"         = "Greg Johnson"
        }
        # (2 unchanged attributes hidden)
    }

  # azurerm_subnet.bot_wvd will be updated in-place
  ~ resource "azurerm_subnet" "bot_wvd" {
        id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"
        name                                          = "mr8-dev-bot-scus-WVD-snet"
      ~ service_endpoints                             = [
          - "Microsoft.Storage",
        ]
        # (7 unchanged attributes hidden)
    }

  # azurerm_subnet.dmz will be updated in-place
  ~ resource "azurerm_subnet" "dmz" {
        id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
        name                                          = "mr8-dev-scus-dmz-snet"
      ~ service_endpoints                             = [
          + "Microsoft.KeyVault, Microsoft.Storage",
        ]
        # (7 unchanged attributes hidden)
    }

  # azurerm_subnet.internal will be updated in-place
  ~ resource "azurerm_subnet" "internal" {
        id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
        name                                          = "mr8-dev-scus-internal-snet"
      ~ service_endpoints                             = [
          - "Microsoft.KeyVault",
          - "Microsoft.Storage",
        ]
        # (7 unchanged attributes hidden)
    }

  # azurerm_subnet.wvd will be updated in-place
  ~ resource "azurerm_subnet" "wvd" {
        id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"
        name                                          = "mr8-dev-scus-WVD-snet"
      ~ service_endpoints                             = [
          - "Microsoft.KeyVault",
          - "Microsoft.Storage",
          + "Microsoft.KeyVault, Microsoft.Storage",
        ]
        # (7 unchanged attributes hidden)
    }

  # azurerm_subnet_network_security_group_association.assoc_bot_wvd must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_bot_wvd" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet" -> (known after apply)
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_network_security_group_association.assoc_dmz must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_dmz" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet" -> (known after apply)
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_network_security_group_association.assoc_internal must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_internal" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet" -> (known after apply)
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_network_security_group_association.assoc_wvd must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_wvd" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet" -> (known after apply)
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_virtual_machine.vm["buildcontroller_test"] will be created
  + resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "southcentralus"
      + name                             = "BUILDCONTROLLER-test"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "mr8-dev-rg"
      + vm_size                          = "Standard_D2as_v5"

      + boot_diagnostics {
          + enabled     = true
          + storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + storage_data_disk (known after apply)

      + storage_image_reference (known after apply)

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "Attach"
          + disk_size_gb              = 100
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "BUILDCONTROLLER-OSdisk-00-test"
          + os_type                   = "Windows"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine.vm_buildcontroller will be destroyed
  # (because azurerm_virtual_machine.vm_buildcontroller is not in configuration)
  - resource "azurerm_virtual_machine" "vm_buildcontroller" {
      - id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILDCONTROLLER-test" -> null
      - location                     = "southcentralus" -> null
      - name                         = "BUILDCONTROLLER-test" -> null
      - network_interface_ids        = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test",
        ] -> null
      - primary_network_interface_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test" -> null
      - resource_group_name          = "mr8-dev-rg" -> null
      - tags                         = {} -> null
      - vm_size                      = "Standard_D2as_v5" -> null
      - zones                        = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
          - storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net" -> null
        }

      - identity {
          - identity_ids = [] -> null
          - principal_id = "59349bd0-4d8f-452a-8e07-880d71c29dc3" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "Attach" -> null
          - disk_size_gb              = 100 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "BUILDCONTROLLER-OSdisk-00-test" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_network.main_vnet will be updated in-place
  ~ resource "azurerm_virtual_network" "main_vnet" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet"
        name                           = "mr8-dev-scus-vnet"
      ~ tags                           = {
          + "domain"      = "Keais"
          + "domain"      = "Keais"
            "environment" = "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (10 unchanged attributes hidden)
    }

Plan: 7 to add, 10 to change, 7 to destroy.


















