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


terraform import azurerm_subnet_network_security_group_association.<NAME> \
"<SUBNET_ID>|<NSG_ID>"




#!/bin/bash

# Resource Group
RG="mr8-dev-rg"
VNET="mr8-dev-scus-vnet"

# Declare subnet/NSG name pairs
declare -A MAP
MAP["assoc_internal"]="mr8-dev-scus-internal-snet|mr8-dev-scus-internal-nsg"
MAP["assoc_wvd"]="mr8-dev-scus-WVD-snet|mr8-dev-scus-wvd-nsg"
MAP["assoc_dmz"]="mr8-dev-scus-dmz-snet|mr8-dev-scus-dmz-nsg"
MAP["assoc_bot_wvd"]="mr8-dev-bot-scus-WVD-snet|mr8-dev-bot-scus-WVD-nsg"

for assoc in "${!MAP[@]}"; do
  # Split subnet and NSG names
  IFS="|" read -r SUBNET_NAME NSG_NAME <<< "${MAP[$assoc]}"

  # Get IDs from Azure
  SUBNET_ID=$(az network vnet subnet show -g $RG --vnet-name $VNET -n $SUBNET_NAME --query id -o tsv)
  NSG_ID=$(az network nsg show -g $RG -n $NSG_NAME --query id -o tsv)

  # Combine with |
  IMPORT_ID="${SUBNET_ID}|${NSG_ID}"

  echo "Importing $assoc ..."
  terraform import azurerm_subnet_network_security_group_association.$assoc "$IMPORT_ID"
done




