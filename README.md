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

  # azurerm_virtual_machine.vm["dvkib2_9"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-9" -> null
      - location              = "southcentralus" -> null
      - name                  = "dvkib2-9" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-9-nic",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "Domain"             = "Keaisinc"
          - "Owner"              = "Greg Johnson"
          - "cm-resource-parent" = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.DesktopVirtualization/hostpools/MR8WVD-Dev-Automation-Bot-02"
          - "environment"        = "Development"
          - "name"               = "Keaisinc"
        } -> null
      - vm_size               = "Standard_D4as_v5" -> null
      - zones                 = [] -> null

      - additional_capabilities {}

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
          - id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1" -> null
            # (4 unchanged attributes hidden)
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 256 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" -> null
          - managed_disk_type         = "StandardSSD_LRS" -> null
          - name                      = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_app01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-APP01" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVKIB2-APP01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-app01435",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "environment" = "development"
        } -> null
      - vm_size               = "Standard_D2s_v4" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-Datacenter" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_def01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-DEF01" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVKIB2-DEF01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-def01508",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "domain"      = "keaisinc"
          - "environment" = "development"
          - "owner"       = "Jaspinder Singh"
        } -> null
      - vm_size               = "Standard_B2s" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - identity {
          - identity_ids = [] -> null
          - principal_id = "fab5ba7d-6e4d-49b5-b182-c6ecb54b7ae6" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-datacenter-gensecond" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-DEF01_osdisk1" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-DEF01_osdisk1" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVKIB2-RPA01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa01497",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "Business Unit" = "Keais"
          - "domain"        = "keaisinc"
          - "environment"   = "development"
          - "owner"         = "Greg Johnson"
        } -> null
      - vm_size               = "Standard_B8s_v2" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - identity {
          - identity_ids = [] -> null
          - principal_id = "63cc7c8d-966f-4519-b446-b6b8dc644d3b" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

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

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-datacenter-gensecond" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa02"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVKIB2-RPA02" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa02608",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "Business Unit" = "Keais"
          - "domain"        = "keaisinc"
          - "environment"   = "development"
          - "owner"         = "Greg Johnson"
        } -> null
      - vm_size               = "Standard_B16s_v2" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - identity {
          - identity_ids = [] -> null
          - principal_id = "d7d174bb-1837-46a2-a066-98e390555b11" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_data_disk {
          - caching                   = "ReadOnly" -> null
          - create_option             = "Attach" -> null
          - disk_size_gb              = 512 -> null
          - lun                       = 0 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA02_DataDisk_0" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-RPA02_DataDisk_0" -> null
          - write_accelerator_enabled = false -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-datacenter-gensecond" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 256 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_web01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB01" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVKIB2-WEB01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-web01177",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {} -> null
      - vm_size               = "Standard_E2s_v4" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-Datacenter" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-WEB01_OsDisk_1_2983fb975b9d45bc806d054ea09c2dd7" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-WEB01_OsDisk_1_2983fb975b9d45bc806d054ea09c2dd7" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_web02"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB02" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVKIB2-WEB02" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-web02469",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {} -> null
      - vm_size               = "Standard_E2s_v4" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-Datacenter" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-WEB02_OsDisk_1_c3cb151d066246e88dee0e84a975e5f8" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVKIB2-WEB02_OsDisk_1_c3cb151d066246e88dee0e84a975e5f8" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvwgb2_ftp01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVWGB2-FTP01" -> null      
      - location              = "southcentralus" -> null
      - name                  = "DVWGB2-FTP01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvwgb2-ftp01208",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "environment" = "development"
        } -> null
      - vm_size               = "Standard_D2s_v4" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-Datacenter" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVWGB2-FTP01_OsDisk_1_0c78f25d49004de5ab80fa6a95b15f2a" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "DVWGB2-FTP01_OsDisk_1_0c78f25d49004de5ab80fa6a95b15f2a" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["kib2_nsb01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KIB2-NSB01" -> null        
      - location              = "southcentralus" -> null
      - name                  = "KIB2-NSB01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/kib2-nsb01216",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "domain"      = "keaisinc"
          - "environment" = "development"
          - "owner"       = "Jaspinder Singh"
          - "service"     = "NServiceBus"
        } -> null
      - vm_size               = "Standard_B4ms" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - identity {
          - identity_ids = [] -> null
          - principal_id = "76b968bc-de0e-4bf1-8df5-b50b21c6cb40" -> null
          - tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> null
          - type         = "SystemAssigned" -> null
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-datacenter-gensecond" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/KIB2-NSB01_osdisk1" -> null  
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "KIB2-NSB01_osdisk1" -> null
          - os_type                   = "Windows" -> null
          - write_accelerator_enabled = false -> null
            # (2 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["qakib2_opg01"] will be destroyed
  # (because azurerm_virtual_machine.vm is not in configuration)
  - resource "azurerm_virtual_machine" "vm" {
      - id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/QAKIB2-OPG01" -> null      
      - location              = "southcentralus" -> null
      - name                  = "QAKIB2-OPG01" -> null
      - network_interface_ids = [
          - "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/qakib2-opg01829",
        ] -> null
      - resource_group_name   = "mr8-dev-rg" -> null
      - tags                  = {
          - "environment" = "development"
        } -> null
      - vm_size               = "Standard_E2s_v4" -> null
      - zones                 = [] -> null

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      - storage_image_reference {
            id        = null
          - offer     = "WindowsServer" -> null
          - publisher = "MicrosoftWindowsServer" -> null
          - sku       = "2019-Datacenter" -> null
          - version   = "latest" -> null
        }

      - storage_os_disk {
          - caching                   = "ReadWrite" -> null
          - create_option             = "FromImage" -> null
          - disk_size_gb              = 127 -> null
          - managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/QAKIB2-OPG01_OsDisk_1_2ee33f23ad8f46a3b8950669b134e049" -> null
          - managed_disk_type         = "Premium_LRS" -> null
          - name                      = "QAKIB2-OPG01_OsDisk_1_2ee33f23ad8f46a3b8950669b134e049" -> null
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
            "environment" = "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (10 unchanged attributes hidden)
    }

Plan: 4 to add, 19 to change, 26 to destroy.
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_app01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["kib2_nsb01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the   
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_rpa01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_web01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["qakib2_opg01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_web02"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_rpa02"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_def01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvkib2_9"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the     
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Instance cannot be destroyed
│
│   on disks.tf line 2:
│    2: resource "azurerm_managed_disk" "os" {
│
│ Resource azurerm_managed_disk.os["dvwgb2_ftp01"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the 
│ plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
╷
│ Error: Invalid combination of arguments
│
│   with azurerm_windows_virtual_machine.vm_new_win["kib2_nsb01"],
│   on vms.tf line 45, in resource "azurerm_windows_virtual_machine" "vm_new_win":
│   45: resource "azurerm_windows_virtual_machine" "vm_new_win" {
│
│ "source_image_reference": one of `source_image_id,source_image_reference` must be specified
╵
╷
│ Error: "admin_password" must not be empty
│
│   with azurerm_windows_virtual_machine.vm_new_win["kib2_nsb01"],
│   on vms.tf line 53, in resource "azurerm_windows_virtual_machine" "vm_new_win":
│   53:   admin_password        = lookup(each.value.os_profiles, "admin_password", null)
│
╵
╷
│ Error: Invalid combination of arguments
│
│   with azurerm_windows_virtual_machine.vm_new_win["kib2_nsb01"],
│   on vms.tf line 54, in resource "azurerm_windows_virtual_machine" "vm_new_win":
│   54:   source_image_id       = lookup(each.value.image_reference, "id", null)
│
│ "source_image_id": one of `source_image_id,source_image_reference` must be specified
