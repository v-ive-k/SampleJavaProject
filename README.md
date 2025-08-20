terraform import azurerm_virtual_network.main_vnet \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet"




terraform import azurerm_subnet.internal \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"

terraform import azurerm_subnet.wvd \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet"

terraform import azurerm_subnet.dmz \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"

terraform import azurerm_subnet.bot_wvd \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet"




terraform import azurerm_network_security_group.nsg_internal \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"

terraform import azurerm_network_security_group.nsg_wvd \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-WVD-nsg"

terraform import azurerm_network_security_group.nsg_dmz \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"

terraform import azurerm_network_security_group.nsg_bot_wvd \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"



