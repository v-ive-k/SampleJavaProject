az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform plan
var.owner
  Enter a value: 

azurerm_subnet.wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-wvd-snet]
azurerm_subnet.bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-wvd-snet]
azurerm_subnet.dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_network_security_group.nsg_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-wvd-nsg]
azurerm_network_security_group.nsg_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg]
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg] 
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_virtual_network.main_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet]
azurerm_network_security_group.nsg_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg]
azurerm_network_security_group.nsg_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg]
azurerm_subnet_network_security_group_association.assoc_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]     
azurerm_subnet_network_security_group_association.assoc_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]     

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following 
symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # azurerm_network_security_group.nsg_bot_wvd must be replaced
-/+ resource "azurerm_network_security_group" "nsg_bot_wvd" {
      ~ id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-wvd-nsg" -> (known after apply)
      ~ name                = "mr8-dev-bot-scus-wvd-nsg" -> "mr8-dev-bot-scus-WVD-nsg" # forces replacement
      ~ resource_group_name = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      ~ security_rule       = [] -> (known after apply)
      - tags                = {} -> null
        # (1 unchanged attribute hidden)
    }

  # azurerm_network_security_group.nsg_dmz must be replaced
-/+ resource "azurerm_network_security_group" "nsg_dmz" {
      ~ id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg" -> (known after apply)
        name                = "mr8-dev-scus-dmz-nsg"
      ~ resource_group_name = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      ~ security_rule       = [
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "22"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "SSH"
              - priority                                   = 4094
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.65.0/24"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Outbound"
              - name                                       = "Out_DMZ-DMZ_Deny"
              - priority                                   = 4095
              - protocol                                   = "*"
              - source_address_prefix                      = "10.239.65.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.65.0/24"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In-DD1-HVWT513-WGRSB2-MGT"
              - priority                                   = 130
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.239.64.4"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.65.0/24"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "InfraAVDs_to_DVKIWG"
              - priority                                   = 122
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.249.24.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.65.19"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "AllowCidrBlockRDPInbound"
              - priority                                   = 110
              - protocol                                   = "*"
              - source_address_prefix                      = "10.249.64.15"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.65.4/32"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "KIC1-ADC01-TO-DVKIB2-WEB03"
              - priority                                   = 121
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.91.0.161/32"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - description                                = "Dev Azure Firewall to DVWGB-FTP01"
              - destination_address_prefix                 = "10.239.65.19"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "10022"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In-DevFW_to_DVWGB-FTP01_SFTP_Allow"
              - priority                                   = 4090
              - protocol                                   = "*"
              - source_address_prefix                      = "10.239.3.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Allow"
              - description                                = "RDP Management to DV SFTP"
              - destination_address_prefix                 = "10.239.65.19"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In-KIB2-MGT01_to_DVWGB2-FTP01_Allow_RDP"
              - priority                                   = 120
              - protocol                                   = "Tcp"
              - source_address_prefixes                    = [
                  - "10.239.64.4",
                  - "10.239.64.6",
                ]
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - description                                = "Rule to deny all connections between DMZ servers."
              - destination_address_prefix                 = "10.239.65.0/24"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "MR8-DMZ-TO-MR8-DMZ_Deny"
              - priority                                   = 4095
              - protocol                                   = "*"
              - source_address_prefix                      = "10.239.65.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Deny"
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In-Any_to_MR8-DMZ_Deny_All"
              - priority                                   = 4093
              - protocol                                   = "*"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
        ] -> (known after apply)
      - tags                = {
          - "environment" = "development"
        } -> null
        # (1 unchanged attribute hidden)
    }

  # azurerm_network_security_group.nsg_internal must be replaced
-/+ resource "azurerm_network_security_group" "nsg_internal" {
      ~ id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg" -> (known after apply)
        name                = "mr8-dev-scus-internal-nsg"
      ~ resource_group_name = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      ~ security_rule       = [
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "*"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "AllowAnyCustom3389Inbound"
              - priority                                   = 220
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "*"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.64.10/32"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "1433"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In_Dev_WGKIB2-Web_DVKIB2-SQL01"
              - priority                                   = 400
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.239.65.19/32"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.64.13"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "KIB2-W10DEV-15-to-DVKIB2-W10RPA01-RDP"
              - priority                                   = 210
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.239.66.18"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (1 unchanged attribute hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.64.9"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "6600"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "AllowCidrBlockCustom6600Inbound"
              - priority                                   = 102
              - protocol                                   = "*"
              - source_address_prefixes                    = [
                  - "10.91.130.0/24",
                  - "10.91.3.0/24",
                ]
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (2 unchanged attributes hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.239.64.9"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "80"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "AllowAnyHTTPInbound"
              - priority                                   = 101
              - protocol                                   = "Tcp"
              - source_address_prefixes                    = [
                  - "10.91.130.0/24",
                  - "10.91.3.0/24",
                ]
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (2 unchanged attributes hidden)
            },
          - {
              - access                                     = "Allow"
              - destination_address_prefix                 = "10.249.64.10/32"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_ranges                    = [
                  - "137-139",
                  - "445",
                ]
              - direction                                  = "Inbound"
              - name                                       = "In_Dev_WGKIB1-FTP01-KIB1-APP01_SMB"
              - priority                                   = 500
              - protocol                                   = "*"
              - source_address_prefix                      = "10.239.65.19/32"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
                # (2 unchanged attributes hidden)
            },
          - {
              - access                                     = "Allow"
              - description                                = "Allow 1433 for MSSQL from Web02 to SQL01"
              - destination_address_prefix                 = "10.239.64.10"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "1433"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In_Dev_DVKIB2-WEB02-DVKIB2-SQL01_MSSQL"
              - priority                                   = 300
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.239.65.18/32"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Allow"
              - description                                = "Allow 1433 for SQL from Web01 to SQL01."
              - destination_address_prefix                 = "10.239.64.10"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "1433"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In_Dev_DVKIB2-WEB01-DVKIB2-WQL01_MSSQL"
              - priority                                   = 200
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.239.65.17"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Allow"
              - description                                = "Rule to allow ICMP from DMZ to Internal for testing.  Should only be enabled if needed for network testing."
              - destination_address_prefix                 = "10.239.64.0/24"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In_Dev_DMZ-INT_Allow_ICMP"
              - priority                                   = 100
              - protocol                                   = "Icmp"
              - source_address_prefix                      = "10.239.65.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Allow"
              - description                                = "Ticket#113998"
              - destination_address_prefix                 = "10.239.64.80"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "3389"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "In_Dev_VPN-KIB2-NSB01_RDP_ALLOW"
              - priority                                   = 211
              - protocol                                   = "Tcp"
              - source_address_prefix                      = "10.91.130.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
          - {
              - access                                     = "Deny"
              - description                                = "Default deny rule for connections from the DMZ Subnet to the Internal Subnet."
              - destination_address_prefix                 = "10.239.64.0/24"
              - destination_address_prefixes               = []
              - destination_application_security_group_ids = []
              - destination_port_range                     = "*"
              - destination_port_ranges                    = []
              - direction                                  = "Inbound"
              - name                                       = "in_Dev_DMZ-INT_Deny_All"
              - priority                                   = 4096
              - protocol                                   = "*"
              - source_address_prefix                      = "10.239.65.0/24"
              - source_address_prefixes                    = []
              - source_application_security_group_ids      = []
              - source_port_range                          = "*"
              - source_port_ranges                         = []
            },
        ] -> (known after apply)
      - tags                = {
          - "environment" = "development"
        } -> null
        # (1 unchanged attribute hidden)
    }

  # azurerm_network_security_group.nsg_wvd must be replaced
-/+ resource "azurerm_network_security_group" "nsg_wvd" {
      ~ id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg" -> (known after apply)
        name                = "mr8-dev-scus-wvd-nsg"
      ~ resource_group_name = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      ~ security_rule       = [] -> (known after apply)
      - tags                = {
          - "Workload"    = "WVD Dev"
          - "environment" = "development"
        } -> null
        # (1 unchanged attribute hidden)
    }

  # azurerm_resource_group.rg must be replaced
-/+ resource "azurerm_resource_group" "rg" {
      ~ id         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg" -> (known after apply)       
      ~ name       = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      ~ tags       = {
          - "Business Unit" = "Keais" -> null
          + "domain"        = "Keais"
            "environment"   = "Development"
          + "managed by"    = "terraform"
          + "owner"         = "Greg Johnson"
        }
        # (2 unchanged attributes hidden)
    }

  # azurerm_subnet.bot_wvd must be replaced
-/+ resource "azurerm_subnet" "bot_wvd" {
      ~ id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-wvd-snet" -> (known after apply)      
      ~ name                                          = "mr8-dev-bot-scus-wvd-snet" -> "mr8-dev-bot-scus-WVD-snet" # forces replacement
      ~ resource_group_name                           = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      - service_endpoint_policy_ids                   = [] -> null
      - service_endpoints                             = [
          - "Microsoft.Storage",
        ] -> null
        # (5 unchanged attributes hidden)
    }

  # azurerm_subnet.dmz must be replaced
-/+ resource "azurerm_subnet" "dmz" {
      ~ id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet" -> (known after apply)
        name                                          = "mr8-dev-scus-dmz-snet"
      ~ private_endpoint_network_policies             = "Enabled" -> "Disabled"
      ~ resource_group_name                           = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      - service_endpoint_policy_ids                   = [] -> null
      - service_endpoints                             = [] -> null
        # (4 unchanged attributes hidden)
    }

  # azurerm_subnet.internal must be replaced
-/+ resource "azurerm_subnet" "internal" {
      ~ id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet" -> (known after apply)     
        name                                          = "mr8-dev-scus-internal-snet"
      ~ resource_group_name                           = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      - service_endpoint_policy_ids                   = [] -> null
      - service_endpoints                             = [
          - "Microsoft.KeyVault",
          - "Microsoft.Storage",
        ] -> null
        # (5 unchanged attributes hidden)
    }

  # azurerm_subnet.wvd must be replaced
-/+ resource "azurerm_subnet" "wvd" {
      ~ id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-wvd-snet" -> (known after apply)
      ~ name                                          = "mr8-dev-scus-wvd-snet" -> "mr8-dev-scus-WVD-snet" # forces replacement   
      ~ private_endpoint_network_policies             = "Enabled" -> "Disabled"
      ~ resource_group_name                           = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      - service_endpoint_policy_ids                   = [] -> null
      - service_endpoints                             = [
          - "Microsoft.KeyVault",
          - "Microsoft.Storage",
        ] -> null
        # (4 unchanged attributes hidden)
    }

  # azurerm_subnet_network_security_group_association.assoc_bot_wvd must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_bot_wvd" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet" -> (known after apply)
      ~ network_security_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg" -> (known after apply) # forces replacement
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet" -> (known after apply) # forces replacement     
    }

  # azurerm_subnet_network_security_group_association.assoc_dmz must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_dmz" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet" -> (known after apply)
      ~ network_security_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg" -> (known after apply) # forces replacement
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet" -> (known after apply) # forces replacement
    }

  # azurerm_subnet_network_security_group_association.assoc_internal must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_internal" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet" -> (known after apply)
      ~ network_security_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg" -> (known after apply) # forces replacement
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet" -> (known after apply) # forces replacement    
    }

  # azurerm_subnet_network_security_group_association.assoc_wvd must be replaced
-/+ resource "azurerm_subnet_network_security_group_association" "assoc_wvd" {
      ~ id                        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet" -> (known after apply)
      ~ network_security_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg" -> (known after apply) # forces replacement
      ~ subnet_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet" -> (known after apply) # forces replacement
    }

  # azurerm_virtual_network.main_vnet must be replaced
-/+ resource "azurerm_virtual_network" "main_vnet" {
      - flow_timeout_in_minutes        = 0 -> null
      ~ guid                           = "8e3880f3-4f42-49b5-8abe-32717d924a8b" -> (known after apply)
      ~ id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet" -> (known after apply)
        name                           = "mr8-dev-scus-vnet"
      ~ resource_group_name            = "mr8-dev-rg" -> "MR8-Dev-rg" # forces replacement
      ~ subnet                         = [
          - {
              - address_prefixes                              = [
                  - "10.239.64.0/24",
                ]
              - default_outbound_access_enabled               = false
              - delegation                                    = []
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
              - name                                          = "mr8-dev-scus-internal-snet"
              - private_endpoint_network_policies             = "Disabled"
              - private_link_service_network_policies_enabled = true
              - route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              - security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"
              - service_endpoint_policy_ids                   = []
              - service_endpoints                             = [
                  - "Microsoft.KeyVault",
                  - "Microsoft.Storage",
                ]
            },
          - {
              - address_prefixes                              = [
                  - "10.239.65.0/24",
                ]
              - default_outbound_access_enabled               = false
              - delegation                                    = []
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
              - name                                          = "mr8-dev-scus-dmz-snet"
              - private_endpoint_network_policies             = "Enabled"
              - private_link_service_network_policies_enabled = true
              - route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              - security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"
              - service_endpoint_policy_ids                   = []
              - service_endpoints                             = []
            },
          - {
              - address_prefixes                              = [
                  - "10.239.66.0/26",
                ]
              - default_outbound_access_enabled               = false
              - delegation                                    = []
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"
              - name                                          = "mr8-dev-scus-WVD-snet"
              - private_endpoint_network_policies             = "Enabled"
              - private_link_service_network_policies_enabled = true
              - route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              - security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"
              - service_endpoint_policy_ids                   = []
              - service_endpoints                             = [
                  - "Microsoft.KeyVault",
                  - "Microsoft.Storage",
                ]
            },
          - {
              - address_prefixes                              = [
                  - "10.239.66.64/26",
                ]
              - default_outbound_access_enabled               = false
              - delegation                                    = []
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"
              - name                                          = "mr8-dev-bot-scus-WVD-snet"
              - private_endpoint_network_policies             = "Disabled"
              - private_link_service_network_policies_enabled = true
              - route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              - security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"
              - service_endpoint_policy_ids                   = []
              - service_endpoints                             = [
                  - "Microsoft.Storage",
                ]
            },
        ] -> (known after apply)
      ~ tags                           = {
          + "domain"      = "Keais"
            "environment" = "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (6 unchanged attributes hidden)
    }

Plan: 14 to add, 0 to change, 14 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run     
"terraform apply" now.
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$
