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

az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az group show -n mr8-dev-rg --query name -o tsv
mr8-dev-rg
mr8-dev-scus-vnet
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az network vnet subnet list -g mr8-dev-rg --vnet-name mr8-dev-scus-vnet --query "[].name" -o tsv
mr8-dev-scus-internal-snet
mr8-dev-scus-WVD-snet
mr8-dev-scus-dmz-snet
mr8-dev-bot-scus-WVD-snet
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az network nsg list -g mr8-dev-rg --query "[].name" -o tsv
mr8-dev-bot-scus-WVD-nsg
mr8-dev-scus-dmz-nsg
mr8-dev-scus-internal-nsg
mr8-dev-scus-wvd-nsg
temp-dev-vnet-01-NSG





