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

#Resource Group Variales
rg_name       = "mr8-dev-rg"
location_name = "South Central US"

# TAGS!
global_tags = {
  "environment" = "Development"
  "domain"      = "Keais"
  "owner"       = "Greg Johnson"
  "managed by"  = "terraform"

}


# V-net Variables
main_vnet_name          = "mr8-dev-scus-vnet"
main_vnet_address_space = ["10.239.64.0/22"]
main_dns_servers        = ["10.249.8.4", "10.249.8.5"]

# Subnet Variables
internal_snet_name           = "mr8-dev-scus-internal-snet"
internal_snet_address_prefix = "10.239.64.0/24"
wvd_snet_name                = "mr8-dev-scus-WVD-snet"
wvd_snet_address_prefix      = "10.239.66.0/26"
dmz_snet_name                = "mr8-dev-scus-dmz-snet"
dmz_snet_address_prefix      = "10.239.65.0/24"
bot_wvd_snet_name            = "mr8-dev-bot-scus-WVD-snet"
bot_wvd_snet_address_prefix  = "10.239.66.64/26"

# NSG Variables
nsg_internal_name = "mr8-dev-scus-internal-nsg"
nsg_wvd_name      = "mr8-dev-scus-wvd-nsg"
nsg_dmz_name      = "mr8-dev-scus-dmz-nsg"
nsg_bot_wvd_name  = "mr8-dev-bot-scus-WVD-nsg"







