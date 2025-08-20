az group show -n mr8-dev-rg --query name -o tsv
az network vnet show -g mr8-dev-rg -n mr8-dev-scus-vnet --query name -o tsv
az network vnet subnet list -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet --query "[].name" -o tsv
az network nsg list -g mr8-dev-rg --query "[].name" -o tsv




terraform state show azurerm_subnet_network_security_group_association.assoc_internal




terraform state rm azurerm_subnet_network_security_group_association.assoc_internal
SUBNET_ID=$(az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-scus-internal-snet --query id -o tsv)
NSG_ID=$(az network nsg show -g mr8-dev-rg -n mr8-dev-scus-internal-nsg --query id -o tsv)
terraform import azurerm_subnet_network_security_group_association.assoc_internal "${SUBNET_ID}|${NSG_ID}"









==================================

# Subnets
az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-scus-internal-snet --query id -o tsv
az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-scus-WVD-snet --query id -o tsv
az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-scus-dmz-snet --query id -o tsv
az network vnet subnet show -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet -n mr8-dev-bot-scus-WVD-snet --query id -o tsv

# NSGs
az network nsg show -g mr8-dev-rg -n mr8-dev-scus-internal-nsg --query id -o tsv
az network nsg show -g mr8-dev-rg -n mr8-dev-scus-wvd-nsg --query id -o tsv
az network nsg show -g mr8-dev-rg -n mr8-dev-scus-dmz-nsg --query id -o tsv
az network nsg show -g mr8-dev-rg -n mr8-dev-bot-scus-WVD-nsg --query id -o tsv








