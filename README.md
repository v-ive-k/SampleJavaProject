terraform import azurerm_resource_group.mr8-dev-rg /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/mr8-dev-rg
export SUBID=$(az account show --query id -o tsv)

source ~/.bashrc
