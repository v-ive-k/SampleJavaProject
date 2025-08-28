Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # azurerm_mssql_virtual_machine.sql_vm["sql1"] must be replaced
-/+ resource "azurerm_mssql_virtual_machine" "sql_vm" {
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01" -> (known after apply)
      + sql_connectivity_port        = 1433
      + sql_connectivity_type        = "PRIVATE"
      ~ tags                         = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      ~ virtual_machine_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-rpa01" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01" # forces replacement
        # (2 unchanged attributes hidden)
    }

  # azurerm_mssql_virtual_machine.sql_vm["sql2"] must be replaced
-/+ resource "azurerm_mssql_virtual_machine" "sql_vm" {
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA02" -> (known after apply)
      + sql_connectivity_port        = 1433
      + sql_connectivity_type        = "PRIVATE"
      ~ tags                         = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      ~ virtual_machine_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-rpa02" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02" # forces replacement
        # (2 unchanged attributes hidden)
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

  # azurerm_network_interface.nic["qakib2_opg01"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/qakib2-opg01829"
        name                           = "qakib2-opg01829"
      ~ tags                           = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
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
          + "Microsoft.KeyVault",
          + "Microsoft.Storage",
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

  # azurerm_virtual_machine.vm["qakib2_opg01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/QAKIB2-OPG01"   
        name                             = "QAKIB2-OPG01"
      ~ tags                             = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (5 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
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

Plan: 6 to add, 29 to change, 6 to destroy.
