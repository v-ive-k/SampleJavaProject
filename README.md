terraform import azurerm_subnet_network_security_group_association.assoc_internal \
"/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"



SUBNET_ID=$(az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-scus-internal-snet --query id -o tsv)
echo "$SUBNET_ID/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg"
