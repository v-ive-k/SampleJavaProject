                                                                   "dvkiwgb2_web03" = {
  name           = "dvkiwgb2-web03-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web04" = {
  name           = "dvkiwgb2-web04-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web05" = {
  name           = "dvkiwgb2-web05-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkib2_dts01" = {
  name           = "dvkib2-dts01-nic"
  subnet_key     = "internal"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
}








"dvkiwgb2_web03" = {
  name                 = "DVKIWGB2-WEB03_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web04" = {
  name                 = "DVKIWGB2-WEB04_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web05" = {
  name                 = "DVKIWGB2-WEB05_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkib2_dts01" = {
  name                 = "DVKIB2-DTS01_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
}







"dvkiwgb2_web03" = {
  name                    = "dvkiwgb2-web03"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web03"
  os_disk_key             = "dvkiwgb2_web03"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← pulls from KV 'ontadmin'
    computer_name  = "DVKIWGB2-WEB03"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # DMZ: usually NOT domain joined → omit join_domain
},

"dvkiwgb2_web04" = {
  name                    = "dvkiwgb2-web04"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web04"
  os_disk_key             = "dvkiwgb2_web04"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB04"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkiwgb2_web05" = {
  name                    = "dvkiwgb2-web05"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web05"
  os_disk_key             = "dvkiwgb2_web05"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB05"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkib2_dts01" = {
  name                    = "dvkib2-dts01"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkib2_dts01"
  os_disk_key             = "dvkib2_dts01"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← KV 'ontadmin'
    computer_name  = "DVKIB2-DTS01"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # Internal → domain join ON
  join_domain = true
  ou_path     = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
}



=====================================


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # azurerm_managed_disk.data["dvkib2_mrf01-0"] will be created
  + resource "azurerm_managed_disk" "data" {
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
      + name                              = "DVKIB2-MRF01_DataDisk0"
      + network_access_policy             = "AllowAll"
      + optimized_frequent_attach_enabled = false
      + performance_plus_enabled          = false
      + public_network_access_enabled     = true
      + resource_group_name               = "mr8-dev-rg"
      + source_uri                        = (known after apply)
      + storage_account_type              = "Premium_LRS"
      + tier                              = (known after apply)
    }

  # azurerm_network_interface.nic["dvkib2_9"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-9-nic"
        name                           = "dvkib2-9-nic"
      ~ tags                           = {
          - "Domain"             = "Keaisinc" -> null
          - "Owner"              = "Greg Johnson" -> null
          - "cm-resource-parent" = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourcegroups/mr8-dev-rg/providers/Microsoft.DesktopVirtualization/hostpools/MR8WVD-Dev-Automation-Bot-02" -> null
          + "domain"             = "Keais"
            "environment"        = "Development"
          + "managed by"         = "terraform"
          - "name"               = "Keaisinc" -> null
          + "owner"              = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvkib2_app01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-app01435"
        name                           = "dvkib2-app01435"
      ~ tags                           = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvkib2_def01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-def01508"
        name                           = "dvkib2-def01508"
      ~ tags                           = {
          ~ "domain"      = "keaisinc" -> "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvkib2_mrf01"] will be created
  + resource "azurerm_network_interface" "nic" {
      + accelerated_networking_enabled = false
      + applied_dns_servers            = (known after apply)
      + id                             = (known after apply)
      + internal_domain_name_suffix    = (known after apply)
      + ip_forwarding_enabled          = false
      + location                       = "southcentralus"
      + mac_address                    = (known after apply)
      + name                           = "dvkib2-mrf01nic"
      + private_ip_address             = (known after apply)
      + private_ip_addresses           = (known after apply)
      + resource_group_name            = "mr8-dev-rg"
      + tags                           = {
          + "domain"      = "Keais"
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

  # azurerm_network_interface.nic["dvkib2_rpa01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa01497"
        name                           = "dvkib2-rpa01497"
      ~ tags                           = {
          - "Business Unit" = "Keais" -> null
          ~ "domain"        = "keaisinc" -> "Keais"
          ~ "environment"   = "development" -> "Development"
          + "managed by"    = "terraform"
            "owner"         = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvkib2_rpa02"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa02608"
        name                           = "dvkib2-rpa02608"
      ~ tags                           = {
          - "Business Unit" = "Keais" -> null
          ~ "domain"        = "keaisinc" -> "Keais"
          ~ "environment"   = "development" -> "Development"
          + "managed by"    = "terraform"
            "owner"         = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvkib2_web01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-web01177"
        name                           = "dvkib2-web01177"
      ~ tags                           = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvkib2_web02"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-web02469"
        name                           = "dvkib2-web02469"
      ~ tags                           = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["dvwgb2_ftp01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvwgb2-ftp01208"
        name                           = "dvwgb2-ftp01208"
      ~ tags                           = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_network_interface.nic["kib2_nsb01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/kib2-nsb01216"
        name                           = "kib2-nsb01216"
      ~ tags                           = {
          ~ "domain"      = "keaisinc" -> "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
          - "service"     = "NServiceBus" -> null
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

  # azurerm_subnet_network_security_group_association.assoc_bot_wvd will be created
  + resource "azurerm_subnet_network_security_group_association" "assoc_bot_wvd" {
      + id                        = (known after apply)
      + network_security_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"
      + subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet" 
    }

  # azurerm_subnet_route_table_association.route_table["bot_wvd"] will be created
  + resource "azurerm_subnet_route_table_association" "route_table" {
      + id             = (known after apply)
      + route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
      + subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"
    }

  # azurerm_subnet_route_table_association.route_table["dmz"] will be created
  + resource "azurerm_subnet_route_table_association" "route_table" {
      + id             = (known after apply)
      + route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
      + subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
    }

  # azurerm_subnet_route_table_association.route_table["internal"] will be created
  + resource "azurerm_subnet_route_table_association" "route_table" {
      + id             = (known after apply)
      + route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
      + subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    }

  # azurerm_subnet_route_table_association.route_table["wvd"] will be created
  + resource "azurerm_subnet_route_table_association" "route_table" {
      + id             = (known after apply)
      + route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
      + subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"
    }

  # azurerm_virtual_machine.vm["dvkib2_9"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-9"
        name                             = "dvkib2-9"
      ~ tags                             = {
          - "Domain"             = "Keaisinc" -> null
          - "Owner"              = "Greg Johnson" -> null
          - "cm-resource-parent" = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.DesktopVirtualization/hostpools/MR8WVD-Dev-Automation-Bot-02" -> null
          + "domain"             = "Keais"
            "environment"        = "Development"
          + "managed by"         = "terraform"
          - "name"               = "Keaisinc" -> null
          + "owner"              = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

      - additional_capabilities {}

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_app01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-APP01"
        name                             = "DVKIB2-APP01"
      ~ tags                             = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_def01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-DEF01"
        name                             = "DVKIB2-DEF01"
      ~ tags                             = {
          ~ "domain"      = "keaisinc" -> "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (6 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_mrf01"] will be created
  + resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      + id                               = (known after apply)
      + license_type                     = (known after apply)
      + location                         = "southcentralus"
      + name                             = "dvkib2-mrf01"
      + network_interface_ids            = (known after apply)
      + resource_group_name              = "mr8-dev-rg"
      + tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      + vm_size                          = "Standard_B2ms"

      + os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      + os_profile_windows_config {
          + enable_automatic_upgrades = true
          + provision_vm_agent        = true
            # (1 unchanged attribute hidden)
        }

      + storage_data_disk {
          + caching                   = "None"
          + create_option             = "Attach"
          + disk_size_gb              = 128
          + lun                       = 0
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "DVKIB2-MRF01_DataDisk0"
          + write_accelerator_enabled = false
        }

      + storage_image_reference {
          + id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1"
          + version   = (known after apply)
            # (3 unchanged attributes hidden)
        }

      + storage_os_disk {
          + caching                   = "ReadWrite"
          + create_option             = "FromImage"
          + disk_size_gb              = 128
          + managed_disk_id           = (known after apply)
          + managed_disk_type         = "Premium_LRS"
          + name                      = "DVKIB2-MRF01_OsDisk"
          + os_type                   = "Windows"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01"
        name                             = "DVKIB2-RPA01"
      ~ tags                             = {
          - "Business Unit" = "Keais" -> null
          ~ "domain"        = "keaisinc" -> "Keais"
          ~ "environment"   = "development" -> "Development"
          + "managed by"    = "terraform"
            "owner"         = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (7 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa02"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02"
        name                             = "DVKIB2-RPA02"
      ~ tags                             = {
          - "Business Unit" = "Keais" -> null
          ~ "domain"        = "keaisinc" -> "Keais"
          ~ "environment"   = "development" -> "Development"
          + "managed by"    = "terraform"
            "owner"         = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (7 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_web01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB01"
        name                             = "DVKIB2-WEB01"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_web02"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB02"
        name                             = "DVKIB2-WEB02"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvwgb2_ftp01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVWGB2-FTP01"
        name                             = "DVWGB2-FTP01"
      ~ tags                             = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["kib2_nsb01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KIB2-NSB01"
        name                             = "KIB2-NSB01"
      ~ tags                             = {
          ~ "domain"      = "keaisinc" -> "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
          - "service"     = "NServiceBus" -> null
        }
        # (5 unchanged attributes hidden)

        # (6 unchanged blocks hidden)
    }

  # azurerm_virtual_machine_extension.domain_join["dvkib2_mrf01"] will be created
  + resource "azurerm_virtual_machine_extension" "domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "dvkib2_mrf01-domain-join"
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

Plan: 9 to add, 18 to change, 0 to destroy.
