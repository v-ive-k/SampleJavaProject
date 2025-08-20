resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location_name
  tags     = var.global_tags
}

------------------------------------

#Global Var
variable "global_tags" {}
variable "owner" {}

# Resource Group Variable
variable "rg_name" {}

# Locatoin Variable
variable "location_name" {}

#Networking Variables
variable "main_vnet_name" {}
variable "main_vnet_address_space" {}
variable "main_dns_servers" {}

# Subnet Variables
variable "internal_snet_name" {}
variable "internal_snet_address_prefix" {}
variable "wvd_snet_name" {}
variable "wvd_snet_address_prefix" {}
variable "dmz_snet_name" {}
variable "dmz_snet_address_prefix" {}
variable "bot_wvd_snet_name" {}
variable "bot_wvd_snet_address_prefix" {}

# Network Security Group Variables
variable "nsg_internal_name" {}
variable "nsg_wvd_name" {}
variable "nsg_dmz_name" {}
variable "nsg_bot_wvd_name" {}

-----------------------------------------------------

# Create Virtual Network
resource "azurerm_virtual_network" "main_vnet" {
  name                = var.main_vnet_name
  location            = var.location_name
  resource_group_name = var.rg_name
  address_space       = var.main_vnet_address_space
  dns_servers         = var.main_dns_servers
  tags                = var.global_tags
}

# Creating Subnets
resource "azurerm_subnet" "internal" {
  name                 = var.internal_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.main_vnet_name
  address_prefixes     = [var.internal_snet_address_prefix]
}

resource "azurerm_subnet" "wvd" {
  name                 = var.wvd_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.main_vnet_name
  address_prefixes     = [var.wvd_snet_address_prefix]
}

resource "azurerm_subnet" "dmz" {
  name                 = var.dmz_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.main_vnet_name
  address_prefixes     = [var.dmz_snet_address_prefix]
}

resource "azurerm_subnet" "bot_wvd" {
  name                 = var.bot_wvd_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.main_vnet_name
  address_prefixes     = [var.bot_wvd_snet_address_prefix]
}

# Network Security Groups
resource "azurerm_network_security_group" "nsg_internal" {
  name                = var.nsg_internal_name
  location            = var.location_name
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_group" "nsg_wvd" {
  name                = var.nsg_wvd_name
  location            = var.location_name
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_group" "nsg_dmz" {
  name                = var.nsg_dmz_name
  location            = var.location_name
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_group" "nsg_bot_wvd" {
  name                = var.nsg_bot_wvd_name
  location            = var.location_name
  resource_group_name = var.rg_name
}

# Association NSG's to subnets
resource "azurerm_subnet_network_security_group_association" "assoc_internal" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg_internal.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_wvd" {
  subnet_id                 = azurerm_subnet.wvd.id
  network_security_group_id = azurerm_network_security_group.nsg_wvd.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_dmz" {
  subnet_id                 = azurerm_subnet.dmz.id
  network_security_group_id = azurerm_network_security_group.nsg_dmz.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_bot_wvd" {
  subnet_id                 = azurerm_subnet.bot_wvd.id
  network_security_group_id = azurerm_network_security_group.nsg_bot_wvd.id
}

---------------------------------------------------------

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


