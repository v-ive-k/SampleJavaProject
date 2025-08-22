terraform import azurerm_network_interface.nic_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"


terraform import azurerm_managed_disk.osdisk_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"

terraform import azurerm_windows_virtual_machine.vm_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILD­CONTROLLER-test"



====================

az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform plan -refresh-only
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg]
azurerm_subnet.dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_managed_disk.osdisk_buildcontroller: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test]
azurerm_subnet.wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_network_security_group.nsg_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg]
azurerm_subnet.bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet.internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_virtual_network.main_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet]
azurerm_network_security_group.nsg_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg]
azurerm_network_security_group.nsg_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg]
azurerm_network_security_group.nsg_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg]
azurerm_network_interface.nic_buildcontroller: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test]
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_wvd: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_dmz: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_subnet_network_security_group_association.assoc_internal: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_virtual_machine.vm_buildcontroller: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILDCONTROLLER-test]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply" which may have affected this plan:

  # azurerm_virtual_network.main_vnet has changed
  ~ resource "azurerm_virtual_network" "main_vnet" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet"
        name                           = "mr8-dev-scus-vnet"
      ~ subnet                         = [
          - {
              - address_prefixes                              = [
                  - "10.239.64.0/24",
                ]
              - default_outbound_access_enabled               = false
              - delegation                                    = []
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
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
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
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
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"
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
              - id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"
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
          + {
              + address_prefixes                              = [
                  + "10.239.64.0/24",
                ]
              + default_outbound_access_enabled               = false
              + delegation                                    = []
              + id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
              + name                                          = "mr8-dev-scus-internal-snet"
              + private_endpoint_network_policies             = "Disabled"
              + private_link_service_network_policies_enabled = true
              + route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              + security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"
              + service_endpoint_policy_ids                   = []
              + service_endpoints                             = [
                  + "Microsoft.KeyVault",
                  + "Microsoft.Storage",
                ]
            },
          + {
              + address_prefixes                              = [
                  + "10.239.65.0/24",
                ]
              + default_outbound_access_enabled               = false
              + delegation                                    = []
              + id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
              + name                                          = "mr8-dev-scus-dmz-snet"
              + private_endpoint_network_policies             = "Enabled"
              + private_link_service_network_policies_enabled = true
              + route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              + security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"
              + service_endpoint_policy_ids                   = []
              + service_endpoints                             = []
            },
          + {
              + address_prefixes                              = [
                  + "10.239.66.0/26",
                ]
              + default_outbound_access_enabled               = false
              + delegation                                    = []
              + id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"
              + name                                          = "mr8-dev-scus-WVD-snet"
              + private_endpoint_network_policies             = "Enabled"
              + private_link_service_network_policies_enabled = true
              + route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              + security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"
              + service_endpoint_policy_ids                   = []
              + service_endpoints                             = [
                  + "Microsoft.KeyVault",
                  + "Microsoft.Storage",
                ]
            },
          + {
              + address_prefixes                              = [
                  + "10.239.66.64/26",
                ]
              + default_outbound_access_enabled               = false
              + delegation                                    = []
              + id                                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-Dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"
              + name                                          = "mr8-dev-bot-scus-WVD-snet"
              + private_endpoint_network_policies             = "Disabled"
              + private_link_service_network_policies_enabled = true
              + route_table_id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt"
              + security_group                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"
              + service_endpoint_policy_ids                   = []
              + service_endpoints                             = [
                  + "Microsoft.Storage",
                ]
            },
        ]
        tags                           = {
            "environment" = "Development"
            "owner"       = "Jaspinder Singh"
        }
        # (9 unchanged attributes hidden)
    }


This is a refresh-only plan, so Terraform will not take any actions to undo these. If you were expecting these changes then you can apply this plan to record the updated values in   
the Terraform state without changing any remote objects.
