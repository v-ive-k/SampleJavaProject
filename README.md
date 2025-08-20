

az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-scus-internal-snet --query id -o tsv

az network nsg show -g mr8-dev-rg -n mr8-dev-scus-internal-nsg --query id -o tsv


# Internal Subnet → NSG Association
terraform import azurerm_subnet_network_security_group_association.assoc_internal \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"

# DMZ Subnet → NSG Association
terraform import azurerm_subnet_network_security_group_association.assoc_dmz \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"

# WVD Subnet → NSG Association
terraform import azurerm_subnet_network_security_group_association.assoc_wvd \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-wvd-snet"

# Bot-WVD Subnet → NSG Association
terraform import azurerm_subnet_network_security_group_association.assoc_bot_wvd \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"









az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform state list
azurerm_network_security_group.nsg_bot_wvd
azurerm_network_security_group.nsg_dmz
azurerm_network_security_group.nsg_internal
azurerm_network_security_group.nsg_wvd
azurerm_resource_group.rg
azurerm_subnet.bot_wvd
azurerm_subnet.dmz
azurerm_subnet.internal
azurerm_subnet.wvd
azurerm_subnet_network_security_group_association.assoc_bot_wvd
azurerm_subnet_network_security_group_association.assoc_dmz
azurerm_subnet_network_security_group_association.assoc_internal
azurerm_subnet_network_security_group_association.assoc_wvd
azurerm_virtual_network.main_vnet
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform plan
Acquiring state lock. This may take a few moments...
var.owner
  Enter a value:

azurerm_network_security_group.nsg_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg]
azurerm_network_security_group.nsg_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg]
azurerm_subnet.dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/subscription_id/resourceGroups/mr8-dev-rg]
azurerm_virtual_network.main_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet]
azurerm_network_security_group.nsg_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg]
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_subnet.wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_subnet.bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_network_security_group.nsg_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg]
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_subnet_network_security_group_association.assoc_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # azurerm_network_security_group.nsg_dmz will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_dmz" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"
        name                = "mr8-dev-scus-dmz-nsg"
      ~ tags                = {
          - "environment" = "development" -> null
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_network_security_group.nsg_internal will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_internal" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"
        name                = "mr8-dev-scus-internal-nsg"
      ~ tags                = {
          - "environment" = "development" -> null
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_network_security_group.nsg_wvd will be updated in-place
  ~ resource "azurerm_network_security_group" "nsg_wvd" {
        id                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"
        name                = "mr8-dev-scus-wvd-nsg"
      ~ tags                = {
          - "Workload"    = "WVD Dev" -> null
          - "environment" = "development" -> null
        }
        # (3 unchanged attributes hidden)
    }

  # azurerm_resource_group.rg will be updated in-place
  ~ resource "azurerm_resource_group" "rg" {
        id         = "/subscriptions/subscription_id/resourceGroups/mr8-dev-rg"
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
      ~ private_endpoint_network_policies             = "Enabled" -> "Disabled"
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
      ~ private_endpoint_network_policies             = "Enabled" -> "Disabled"
      ~ service_endpoints                             = [
          - "Microsoft.KeyVault",
          - "Microsoft.Storage",
        ]
        # (6 unchanged attributes hidden)
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

Plan: 4 to add, 9 to change, 4 to destroy.
