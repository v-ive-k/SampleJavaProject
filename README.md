# Internal Subnet → Internal NSG
terraform import azurerm_subnet_network_security_group_association.internal_assoc \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet|/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"

# WVD Subnet → WVD NSG
terraform import azurerm_subnet_network_security_group_association.wvd_assoc \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet|/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-WVD-nsg"

# DMZ Subnet → DMZ NSG
terraform import azurerm_subnet_network_security_group_association.dmz_assoc \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet|/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg"

# BOT WVD Subnet → BOT WVD NSG
terraform import azurerm_subnet_network_security_group_association.bot_wvd_assoc \
"/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet|/subscriptions/<your-subscription-id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg"
