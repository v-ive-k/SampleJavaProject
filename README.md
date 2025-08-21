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


# 1) Get the two IDs
SUBNET_INTERNAL_ID=$(az network vnet subnet show \
  -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet \
  -n mr8-dev-scus-internal-snet --query id -o tsv)

NSG_INTERNAL_ID=$(az network nsg show \
  -g mr8-dev-rg -n mr8-dev-scus-internal-nsg \
  --query id -o tsv)

# 2) Build the single import string (strip any CRs just in case)
ASSOC_INTERNAL_ID=$(echo -n "${SUBNET_INTERNAL_ID}|${NSG_INTERNAL_ID}" | tr -d '\r')

# (optional) sanity check — should display "...subnets/...|...networkSecurityGroups/..."
printf '%s\n' "$ASSOC_INTERNAL_ID"

# 3) Import
terraform import azurerm_subnet_network_security_group_association.assoc_internal "$ASSOC_INTERNAL_ID"








