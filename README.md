terraform import azurerm_subnet.internal "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"

terraform import azurerm_subnet.wvd "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"

terraform import azurerm_subnet.dmz "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"

terraform import azurerm_subnet.bot_wvd "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"

---------------------------------------------------

terraform import azurerm_network_security_group.nsg_internal "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"

terraform import azurerm_network_security_group.nsg_wvd "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"

terraform import azurerm_network_security_group.nsg_dmz "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"

terraform import azurerm_network_security_group.nsg_bot_wvd "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"




-----------------------------------

terraform import azurerm_subnet_network_security_group_association.assoc_internal "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet|/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"

terraform import azurerm_subnet_network_security_group_association.assoc_wvd "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet|/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"

terraform import azurerm_subnet_network_security_group_association.assoc_dmz "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet|/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"

terraform import azurerm_subnet_network_security_group_association.assoc_bot_wvd "/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet|/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"



---------

terraform import azurerm_subnet_network_security_group_association.assoc_internal \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"

terraform import azurerm_subnet_network_security_group_association.assoc_dmz \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"

terraform import azurerm_subnet_network_security_group_association.assoc_wvd \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-wvd-snet\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg"

terraform import azurerm_subnet_network_security_group_association.assoc_bot_wvd \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-wvd-snet\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-wvd-nsg"

-----------------------------------------


az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform import azurerm_subnet_network_security_group_association.assoc_internal \ "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"
var.owner
  Enter a value:

azurerm_subnet_network_security_group_association.assoc_internal: Importing from ID " /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet\\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"...
╷
│ Error: parsing " /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet\\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg": parsing segment "subscriptions": parsing the Subnet ID: the segment at position 0 didn't match
│
│ Expected a Subnet ID that matched:
│
│ > /subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue
│
│ However this value was provided:
│
│ >  /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet\|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg
│
│ The parsed Resource ID was missing a value for the segment at position 0
│ (which should be the literal value "subscriptions").
│



