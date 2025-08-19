az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform import azurerm_virtual_network.main_vnet /subscriptions/subscription_id/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-
dev-scus-vnet
azurerm_virtual_network.main_vnet: Importing from ID "/subscriptions/subscription_id/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet"...
azurerm_virtual_network.main_vnet: Import prepared!
  Prepared azurerm_virtual_network for import
azurerm_virtual_network.main_vnet: Refreshing state... [id=/subscriptions/subscription_id/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet]
╷
│ Error: retrieving Virtual Network (Subscription: "subscription_id"
│ Resource Group Name: "mr8-dev-rg"
│ Virtual Network Name: "mr8-dev-scus-vnet"): unexpected status 400 (400 Bad Request) with error: InvalidSubscriptionId: The provided subscription identifier 'subscription_id' is malformed or invalid.
│
