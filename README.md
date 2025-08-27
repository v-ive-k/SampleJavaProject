terraform state rm azurerm_windows_virtual_machine.vms["STKIB2-SQL02"]
terraform state rm azurerm_network_interface.vm-nics["STKIB2-SQL02"]
terraform state rm azurerm_mssql_virtual_machine.vm-sql["sql02"]
terraform state rm azurerm_managed_disk.vm-sql-disks["sql02-data"]
terraform state rm azurerm_managed_disk.vm-sql-disks["sql02-logs"]
terraform state rm azurerm_managed_disk.vm-sql-disks["sql02-tempdb"]
terraform state rm azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-data"]
terraform state rm azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-logs"]
terraform state rm azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-tempdb"]
terraform state rm azurerm_virtual_machine_extension.vms-domain-join["STKIB2-SQL02"]


+=======================================



Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # azurerm_managed_disk.vm-sql-disks["sql02-data"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 1024
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "STKIB2-SQL02-disk-SQLVMDATA01"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-staging-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tags                              = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.vm-sql-disks["sql02-logs"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 128
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "STKIB2-SQL02-disk-SQLVMLOGS"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-staging-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.vm-sql-disks["sql02-tempdb"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 128
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "STKIB2-SQL02-disk-SQLVMTEMPDB"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-staging-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tags                              = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_mssql_virtual_machine.vm-sql["sql02"] will be created
  + resource "azurerm_mssql_virtual_machine" "vm-sql" {
      + id                    = (known after apply)
      + sql_connectivity_port = 1433
      + sql_connectivity_type = "PRIVATE"
      + sql_license_type      = "PAYG"
      + virtual_machine_id    = (known after apply)

      + storage_configuration {
          + disk_type                      = "NEW"
          + storage_workload_type          = "GENERAL"
          + system_db_on_data_disk_enabled = false

          + data_settings {
              + default_file_path = "F:\\SQLDATA"
              + luns              = [
                  + 1,
                ]
            }

          + log_settings {
              + default_file_path = "G:\\SQLLOG"
              + luns              = [
                  + 2,
                ]
            }

          + temp_db_settings {
              + data_file_count        = 8
              + data_file_growth_in_mb = 512
              + data_file_size_mb      = 256
              + default_file_path      = "H:\\SQLTEMP"
              + log_file_growth_mb     = 512
              + log_file_size_mb       = 256
              + luns                   = [
                  + 0,
                ]
            }
        }
    }

  # azurerm_network_interface.vm-nics["STKIB2-SQL02"] will be created
  + resource "azurerm_network_interface" "vm-nics" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "STKIB2-SQL02-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-staging-rg"
      + tags                           = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "STKIB2-SQL02-nic-ip"
          + primary                                            = (known after apply)
          + private_ip_address                                 = "10.239.56.53"
          + private_ip_address_allocation                      = "Static"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.Network/virtualNetworks/mr8-sta
                                                                                                                                                                                                      aging-scus-vnet/subnets/mr8-staging-scus-internal-snet"
        }
    }

  # azurerm_network_interface.vm-nics["STWGKIB2-WEB02"] will be created
  + resource "azurerm_network_interface" "vm-nics" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "STWGKIB2-WEB02-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-staging-rg"
      + tags                           = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "STWGKIB2-WEB02-nic-ip"
          + primary                                            = (known after apply)
          + private_ip_address                                 = "10.239.57.6"
          + private_ip_address_allocation                      = "Static"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.Network/virtualNetworks/mr8-sta
                                                                                                                                                                                                      aging-scus-vnet/subnets/mr8-staging-scus-dmz-snet"
        }
    }

  # azurerm_subnet_route_table_association.avd_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "avd_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.Network/virtualNetworks/mr8-staging-scus-vnet/subnets/mr8-staging-scus-
                                                                                                                                                                                                      -avd-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c1
                                                                                                                                                                                                      17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_route_table_association.dmz_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "dmz_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.Network/virtualNetworks/mr8-staging-scus-vnet/subnets/mr8-staging-scus-
                                                                                                                                                                                                      -dmz-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c1
                                                                                                                                                                                                      17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_route_table_association.internal_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "internal_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.Network/virtualNetworks/mr8-staging-scus-vnet/subnets/mr8-staging-scus-
                                                                                                                                                                                                      -internal-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c1
                                                                                                                                                                                                      17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_virtual_desktop_host_pool.hostpool01 will be updated in-place
  ~ resource "azurerm_virtual_desktop_host_pool" "hostpool01" {
      ~ custom_rdp_properties            = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:0;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmart
                                                                                                                                                                                                      tcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;" -> "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:0;redirectprinters:
                                                                                                                                                                                                      :i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1"
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STKI-AVD-SHR"        
        name                             = "STKI-AVD-SHR"
        tags                             = {
            "domain"      = "keaisinc"
            "environment" = "staging"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (13 unchanged attributes hidden)
    }

  # azurerm_virtual_desktop_host_pool_registration_info.hostpool01_registrationinfo will be updated in-place
  ~ resource "azurerm_virtual_desktop_host_pool_registration_info" "hostpool01_registrationinfo" {
      ~ expiration_date = "2025-09-26T17:41:55Z" -> (known after apply)
        id              = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STKI-AVD-SHR/registrationInfo/default"
      ~ token           = (sensitive value)
        # (1 unchanged attribute hidden)
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-data"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "ReadOnly"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 1
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-logs"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "None"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 2
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-tempdb"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "ReadOnly"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 0
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_extension.hostpool01_vmext_dsc[0] will be updated in-place
  ~ resource "azurerm_virtual_machine_extension" "hostpool01_vmext_dsc" {
        id                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-staging-rg/providers/Microsoft.Compute/virtualMachines/STKI-AVD-SHR-1/extensions/STKI-AVD
                                                                                                                                                                                                      D-SHR1-avd_dsc"
        name                        = "STKI-AVD-SHR1-avd_dsc"
      ~ protected_settings          = (sensitive value)
        tags                        = {}
        # (9 unchanged attributes hidden)
    }

  # azurerm_virtual_machine_extension.vms-domain-join["STKIB2-SQL02"] will be created
  + resource "azurerm_virtual_machine_extension" "vms-domain-join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STKIB2-SQL02-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = <<-EOT
            {
                  "Name": "keaisinc.com",
                  "OUPath": "OU=Staging,OU=Servers,OU=Azure,DC=keaisinc,DC=com",
                  "User": "svc-keaisjoin@keaisinc.com",
                  "Restart": "true",
                  "Options": "3"
                }
        EOT
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_windows_virtual_machine.vms["STKIB2-SQL02"] will be created
  + resource "azurerm_windows_virtual_machine" "vms" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "ONTAdmin"
      + allow_extension_operations                             = true
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disk_controller_type                                   = (known after apply)
      + enable_automatic_updates                               = false
      + extensions_time_budget                                 = "PT1H30M"
      + hotpatching_enabled                                    = false
      + id                                                     = (known after apply)
      + location                                               = "southcentralus"
      + max_bid_price                                          = -1
      + name                                                   = "STKIB2-SQL02"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "Manual"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "mr8-staging-rg"
      + size                                                   = "Standard_B8ms"
      + tags                                                   = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + timezone                                               = "Central Standard Time"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + boot_diagnostics {}

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = 128
          + id                        = (known after apply)
          + name                      = "STKIB2-SQL02-disk-os"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "sql2022-ws2022"
          + publisher = "microsoftsqlserver"
          + sku       = "sqldev-gen2"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

  # azurerm_windows_virtual_machine.vms["STWGKIB2-WEB02"] will be created
  + resource "azurerm_windows_virtual_machine" "vms" {
      + admin_password                                         = (sensitive value)
      + admin_username                                         = "ONTAdmin"
      + allow_extension_operations                             = true
      + bypass_platform_safety_checks_on_user_schedule_enabled = false
      + computer_name                                          = (known after apply)
      + disk_controller_type                                   = (known after apply)
      + enable_automatic_updates                               = false
      + extensions_time_budget                                 = "PT1H30M"
      + hotpatching_enabled                                    = false
      + id                                                     = (known after apply)
      + location                                               = "southcentralus"
      + max_bid_price                                          = -1
      + name                                                   = "STWGKIB2-WEB02"
      + network_interface_ids                                  = (known after apply)
      + patch_assessment_mode                                  = "ImageDefault"
      + patch_mode                                             = "Manual"
      + platform_fault_domain                                  = -1
      + priority                                               = "Regular"
      + private_ip_address                                     = (known after apply)
      + private_ip_addresses                                   = (known after apply)
      + provision_vm_agent                                     = true
      + public_ip_address                                      = (known after apply)
      + public_ip_addresses                                    = (known after apply)
      + resource_group_name                                    = "mr8-staging-rg"
      + size                                                   = "Standard_B2ms"
      + tags                                                   = {
          + "domain"      = "keaisinc"
          + "environment" = "staging"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + timezone                                               = "Central Standard Time"
      + virtual_machine_id                                     = (known after apply)
      + vm_agent_platform_updates_enabled                      = (known after apply)

      + boot_diagnostics {}

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = 128
          + id                        = (known after apply)
          + name                      = "STWGKIB2-WEB02-disk-os"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "WindowsServer"
          + publisher = "MicrosoftWindowsServer"
          + sku       = "2022-Datacenter"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }





