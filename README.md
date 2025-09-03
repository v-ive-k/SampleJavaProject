# ---- NAT gateway lookup + mapping ----
variable "nat_gateways" {
  # key = alias; value = NAT GW name and optional RG (defaults to var.rg_name)
  type = map(object({
    name                = string
    resource_group_name = optional(string)
  }))
  default = {}
}

# map subnet_key -> nat_gateways key
variable "subnet_to_nat" {
  type    = map(string)
  default = {}
}

# ---- Route table lookup + mapping ----
variable "route_tables" {
  type = map(object({
    name                = string
    resource_group_name = optional(string)
  }))
  default = {}
}

# map subnet_key -> route_tables key
variable "subnet_to_route_table" {
  type    = map(string)
  default = {}
}




=============


# Look up existing NAT Gateways by name (supports cross-RG via resource_group_name)
data "azurerm_nat_gateway" "ngw" {
  for_each            = var.nat_gateways
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, var.rg_name)
}

# Attach selected subnets to their NAT Gateway
resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each       = var.subnet_to_nat
  subnet_id      = local.subnet_ids[each.key]                  # e.g. "internal"
  nat_gateway_id = data.azurerm_nat_gateway.ngw[each.value].id # e.g. "ngw-shared"
}
==============

# Look up existing Route Tables by name (supports cross-RG via resource_group_name)
data "azurerm_route_table" "rt" {
  for_each            = var.route_tables
  name                = each.value.name
  resource_group_name = coalesce(each.value.resource_group_name, var.rg_name)
}

# Attach selected subnets to their Route Table
resource "azurerm_subnet_route_table_association" "this" {
  for_each       = var.subnet_to_route_table
  subnet_id      = local.subnet_ids[each.key]
  route_table_id = data.azurerm_route_table.rt[each.value].id
}
================



# NAT GW lookup (in different RG)
nat_gateways = {
  ngw-shared = {
    name                = "YOUR-NAT-GW-NAME"     # e.g., mr8-dev-shared-ngw
    resource_group_name = "NAT-GW-RG-NAME"       # e.g., mr8-network-rg
  }
}

# Map NAT only to these three subnets; dmz intentionally omitted
subnet_to_nat = {
  internal = "ngw-shared"
  wvd      = "ngw-shared"
  bot_wvd  = "ngw-shared"
}

# Route Table lookup (also in different RG)
route_tables = {
  rt-shared = {
    name                = "YOUR-RT-NAME"         # e.g., mr8-dev-shared-rt
    resource_group_name = "ROUTE-TABLE-RG-NAME"  # e.g., mr8-routing-rg
  }
}

# All four subnets use the same route table
subnet_to_route_table = {
  internal = "rt-shared"
  wvd      = "rt-shared"
  bot_wvd  = "rt-shared"
  dmz      = "rt-shared"
}
 ====

 terraform import 'azurerm_subnet_nat_gateway_association.this["internal"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet

terraform import 'azurerm_subnet_nat_gateway_association.this["wvd"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet

terraform import 'azurerm_subnet_nat_gateway_association.this["bot_wvd"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet




==============



terraform import 'azurerm_subnet_route_table_association.this["internal"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet

terraform import 'azurerm_subnet_route_table_association.this["wvd"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet

terraform import 'azurerm_subnet_route_table_association.this["bot_wvd"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet

terraform import 'azurerm_subnet_route_table_association.this["dmz"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet






