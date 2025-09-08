 # azurerm_managed_disk.vm-sql-disks["sql01-data"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 512
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "DVKIB2-SQL01-disk-SQLVMDATA01"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tags                              = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.vm-sql-disks["sql01-logs"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 200
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "DVKIB2-SQL01-disk-SQLVMLOGS"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.vm-sql-disks["sql02-data"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 650
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "DVKIB2-SQL02-disk-SQLVMDATA"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tags                              = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
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
      + disk_size_gb                      = 200
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "DVKIB2-SQL02-disk-SQLVMLOGS"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.vm-sql-disks["sql03-data"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 512
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "DVKIB2-SQL03-disk-SQLVMDATA"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tags                              = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_managed_disk.vm-sql-disks["sql03-logs"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                     = "Empty"
      + disk_iops_read_only               = (known after apply)
      + disk_iops_read_write              = (known after apply)
      + disk_mbps_read_only               = (known after apply)
      + disk_mbps_read_write              = (known after apply)
      + disk_size_gb                      = 350
      + id                                = (known after apply)
      + location                          = "southcentralus"
      + logical_sector_size               = (known after apply)
      + max_shares                        = (known after apply)
      + name                              = "DVKIB2-SQL03-disk-SQLVMLOGS"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Standard_LRS"
      + tags                              = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + tier                              = (known after apply)
    }

  # azurerm_mssql_virtual_machine.vm-sql["sql01"] will be created
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
                  + 0,
                ]
            }
        }
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
                  + 0,
                ]
            }
        }
    }

  # azurerm_mssql_virtual_machine.vm-sql["sql03"] will be created
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
                  + 0,
                ]
            }
        }
    }

  # azurerm_network_interface.nic["dvkib2_9"] will be created
  + resource "azurerm_network_interface" "nic" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "dvkib2-9-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-dev-rg"
      + tags                           = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "ipconfig"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
        }
    }

  # azurerm_network_interface.nic["dvkib2_dts01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-dts01-nic"
        name                           = "dvkib2-dts01-nic"
        tags                           = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

      ~ ip_configuration {
            name                                               = "ipconfig1"
          ~ private_ip_address_allocation                      = "Static" -> "Dynamic"
            # (6 unchanged attributes hidden)
        }
    }

  # azurerm_network_interface.nic["dvkib2_mrf01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-mrf01nic"
        name                           = "dvkib2-mrf01nic"
        tags                           = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

      ~ ip_configuration {
            name                                               = "ipconfig1"
          ~ private_ip_address_allocation                      = "Static" -> "Dynamic"
            # (6 unchanged attributes hidden)
        }
    }

  # azurerm_network_interface.nic["dvkib2_sql01"] will be created
  + resource "azurerm_network_interface" "nic" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "dvkib2-sql01-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-dev-rg"
      + tags                           = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "ipconfig1"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
        }
    }

  # azurerm_network_interface.nic["dvkib2_sql02"] will be created
  + resource "azurerm_network_interface" "nic" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "dvkib2-sql02-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-dev-rg"
      + tags                           = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "ipconfig1"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
        }
    }

  # azurerm_network_interface.nic["dvkib2_sql03"] will be created
  + resource "azurerm_network_interface" "nic" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "dvkib2-sql03-nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-dev-rg"
      + tags                           = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + virtual_machine_id             = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "ipconfig1"
          + primary                                            = true
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
        }
    }

  # azurerm_network_interface.nic["dvkiwgb2_web03"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkiwgb2-web03-nic"
        name                           = "dvkiwgb2-web03-nic"
        tags                           = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

      ~ ip_configuration {
            name                                               = "ipconfig1"
          ~ private_ip_address_allocation                      = "Static" -> "Dynamic"
            # (6 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["DVKIB2-SQL01"] will be created
  + resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "southcentralus"
      + name                             = "DVKIB2-SQL01"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "mr8-dev-rg"
      + tags                             = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + vm_size                          = "Standard_B8ms"

      + os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_profile_windows_config {
          + enable_automatic_upgrades = true
          + provision_vm_agent        = true
            # (1 unchanged attribute hidden)
        }

      + storage_data_disk (known after apply)

      + storage_image_reference {
            id        = null
          + offer     = "sql2022-ws2022"
          + publisher = "microsoftsqlserver"
          + sku       = "sqldev-gen2"
          + version   = "latest"
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = 128
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "DVKIB2-SQL01_OsDisk"
          + os_type                   = "Windows"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine.vm["DVKIB2-SQL02"] will be created
  + resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "southcentralus"
      + name                             = "DVKIB2-SQL02"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "mr8-dev-rg"
      + tags                             = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + vm_size                          = "Standard_B8ms"

      + os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_profile_windows_config {
          + enable_automatic_upgrades = true
          + provision_vm_agent        = true
            # (1 unchanged attribute hidden)
        }

      + storage_data_disk (known after apply)

      + storage_image_reference {
            id        = null
          + offer     = "sql2022-ws2022"
          + publisher = "microsoftsqlserver"
          + sku       = "sqldev-gen2"
          + version   = "latest"
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = 128
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "DVKIB2-SQL02_OsDisk"
          + os_type                   = "Windows"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine.vm["DVKIB2-SQL03"] will be created
  + resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "southcentralus"
      + name                             = "DVKIB2-SQL03"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "mr8-dev-rg"
      + tags                             = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + vm_size                          = "Standard_B8ms"

      + os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_profile_windows_config {
          + enable_automatic_upgrades = true
          + provision_vm_agent        = true
            # (1 unchanged attribute hidden)
        }

      + storage_data_disk (known after apply)

      + storage_image_reference {
            id        = null
          + offer     = "sql2022-ws2022"
          + publisher = "microsoftsqlserver"
          + sku       = "sqldev-gen2"
          + version   = "latest"
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = 128
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "DVKIB2-SQL03_OsDisk"
          + os_type                   = "Windows"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_9"] will be created
  + resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "southcentralus"
      + name                             = "dvkib2-9"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "mr8-dev-rg"
      + tags                             = {
          + "domain"      = "Keaisinc"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + vm_size                          = "Standard_D4as_v5"

      + os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_profile_windows_config {
          + enable_automatic_upgrades = true
          + provision_vm_agent        = true
            # (1 unchanged attribute hidden)
        }

      + storage_data_disk (known after apply)

      + storage_image_reference {
          + id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1"
          + version   = (known after apply)
            # (3 unchanged attributes hidden)
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = 256
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "StandardSSD_LRS"
          + name                      = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
          + os_type                   = "Windows"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql01-data"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "ReadOnly"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 0
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql01-logs"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "None"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 1
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-data"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "ReadOnly"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 0
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql02-logs"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "None"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 1
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql03-data"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "ReadOnly"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 0
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["sql03-logs"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "None"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 1
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = (known after apply)
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_extension.domain_join["DVKIB2-SQL01"] will be created
  + resource "azurerm_virtual_machine_extension" "domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "DVKIB2-SQL01-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = jsonencode(
            {
              + Name    = "keaisinc.com"
              + OUPath  = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
              + Options = 3
              + Restart = "true"
              + User    = "svc-keaisjoin@keaisinc.com"
            }
        )
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.domain_join["DVKIB2-SQL02"] will be created
  + resource "azurerm_virtual_machine_extension" "domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "DVKIB2-SQL02-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = jsonencode(
            {
              + Name    = "keaisinc.com"
              + OUPath  = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
              + Options = 3
              + Restart = "true"
              + User    = "svc-keaisjoin@keaisinc.com"
            }
        )
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.domain_join["DVKIB2-SQL03"] will be created
  + resource "azurerm_virtual_machine_extension" "domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "DVKIB2-SQL03-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = jsonencode(
            {
              + Name    = "keaisinc.com"
              + OUPath  = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
              + Options = 3
              + Restart = "true"
              + User    = "svc-keaisjoin@keaisinc.com"
            }
        )
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

Plan: 26 to add, 3 to change, 0 to destroy.
