Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_managed_disk.vm-sql-disks["sql01-data"] will be created
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
          + sku       = "sqldev-gen2"
          + version   = "latest"
            # (1 unchanged attribute hidden)
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

  # azurerm_virtual_machine.vm["dvkib2_9"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-9"
        name                             = "dvkib2-9"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - additional_capabilities {}

      - identity {
          - identity_ids = [] -> null
          - principal_id = "69ce4166-6edb-4f68-8f11-cc7a7581525e" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_app01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-APP01"
        name                             = "DVKIB2-APP01"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "f75bf139-a118-4961-bf29-b68ddd4cbbf1" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_dts01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-DTS01"
        name                             = "DVKIB2-DTS01"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "1099e465-c36d-4988-9221-ed7bd04cee43" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (4 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_mrf01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-mrf01"
        name                             = "dvkib2-mrf01"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "fb31a3fc-5a23-4f02-a258-718ff25c3fbd" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_web01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB01"
        name                             = "DVKIB2-WEB01"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "401ac63f-b5a6-44f3-8afc-f2cbbc5c0b33" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_web02"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB02"
        name                             = "DVKIB2-WEB02"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "b6a1214f-991f-4e91-80f7-23c26dd58ae2" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkiwgb2_web03"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIWGB2-WEB03"
        name                             = "DVKIWGB2-WEB03"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "64eb7fe0-60a9-4718-929f-84cb7053a658" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (4 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkiwgb2_web04"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIWGB2-WEB04"
        name                             = "DVKIWGB2-WEB04"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "21228a73-a46a-491a-9882-8b0ffa509cf5" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (4 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkiwgb2_web05"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIWGB2-WEB05"
        name                             = "DVKIWGB2-WEB05"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "665ba081-ada1-4b47-9b98-90ae9ea5cec6" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (4 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvwgb2_ftp01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVWGB2-FTP01"
        name                             = "DVWGB2-FTP01"
        tags                             = {
            "domain"      = "Keaisinc"
            "environment" = "Development"
            "managed by"  = "terraform"
            "owner"       = "Greg Johnson"
        }
        # (7 unchanged attributes hidden)

      - identity {
          - identity_ids = [] -> null
          - principal_id = "3b6a0e39-5560-46f7-bf8f-0e5f31eb7208" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

        # (5 unchanged blocks hidden)
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

Plan: 8 to add, 10 to change, 0 to destroy.
