terraform import azurerm_subnet_network_security_group_association.<assoc_name> \
"/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>/providers/Microsoft.Network/virtualNetworks/<VNET_NAME>/subnets/<SUBNET_NAME>"


terraform import azurerm_subnet_network_security_group_association.app_assoc \
"/subscriptions/${SUBID}/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-app-subnet"


terraform import azurerm_subnet_network_security_group_association.db_assoc \
"/subscriptions/${SUBID}/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-db-subnet"
