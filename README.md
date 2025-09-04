"dvkiwgb2_web03" = {
  name           = "dvkiwgb2-web03-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web04" = {
  name           = "dvkiwgb2-web04-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web05" = {
  name           = "dvkiwgb2-web05-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkib2_dts01" = {
  name           = "dvkib2-dts01-nic"
  subnet_key     = "internal"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
}








"dvkiwgb2_web03" = {
  name                 = "DVKIWGB2-WEB03_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web04" = {
  name                 = "DVKIWGB2-WEB04_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web05" = {
  name                 = "DVKIWGB2-WEB05_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkib2_dts01" = {
  name                 = "DVKIB2-DTS01_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
}







"dvkiwgb2_web03" = {
  name                    = "dvkiwgb2-web03"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web03"
  os_disk_key             = "dvkiwgb2_web03"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← pulls from KV 'ontadmin'
    computer_name  = "DVKIWGB2-WEB03"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # DMZ: usually NOT domain joined → omit join_domain
},

"dvkiwgb2_web04" = {
  name                    = "dvkiwgb2-web04"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web04"
  os_disk_key             = "dvkiwgb2_web04"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB04"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkiwgb2_web05" = {
  name                    = "dvkiwgb2-web05"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web05"
  os_disk_key             = "dvkiwgb2_web05"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB05"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkib2_dts01" = {
  name                    = "dvkib2-dts01"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkib2_dts01"
  os_disk_key             = "dvkib2_dts01"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← KV 'ontadmin'
    computer_name  = "DVKIB2-DTS01"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # Internal → domain join ON
  join_domain = true
  ou_path     = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
}



=====================================


azurerm_subnet_network_security_group_association.assoc_internal: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_subnet_route_table_association.route_table["internal"]: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_subnet_network_security_group_association.assoc_dmz: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_subnet_route_table_association.route_table["dmz"]: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_subnet_route_table_association.route_table["wvd"]: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_subnet_network_security_group_association.assoc_wvd: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_subnet_route_table_association.route_table["bot_wvd"]: Destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_resource_group.rg: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg]
azurerm_virtual_network.main_vnet: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet]
azurerm_resource_group.rg: Modifications complete after 1s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg]
azurerm_managed_disk.data["dvkib2_mrf01-0"]: Creating...
azurerm_managed_disk.data["dvkib2_mrf01-0"]: Creation complete after 3s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-MRF01_DataDisk0]
azurerm_subnet_route_table_association.route_table["dmz"]: Destruction complete after 4s
azurerm_subnet_network_security_group_association.assoc_dmz: Destruction complete after 8s
azurerm_network_security_group.nsg_dmz: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg]
azurerm_subnet_network_security_group_association.assoc_internal: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...net/subnets/mr8-dev-scus-internal-snet, 00m10s elapsed]
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m10s elapsed]
azurerm_subnet_route_table_association.route_table["wvd"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...cus-vnet/subnets/mr8-dev-scus-WVD-snet, 00m10s elapsed]
azurerm_subnet_network_security_group_association.assoc_wvd: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...cus-vnet/subnets/mr8-dev-scus-WVD-snet, 00m10s elapsed]
azurerm_subnet_route_table_association.route_table["internal"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...net/subnets/mr8-dev-scus-internal-snet, 00m10s elapsed]
azurerm_subnet_route_table_association.route_table["bot_wvd"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m10s elapsed]
azurerm_virtual_network.main_vnet: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...work/virtualNetworks/mr8-dev-scus-vnet, 00m10s elapsed]
azurerm_network_security_group.nsg_dmz: Modifications complete after 2s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-dmz-nsg]
azurerm_subnet_network_security_group_association.assoc_dmz: Creating...
azurerm_subnet_network_security_group_association.assoc_bot_wvd: Destruction complete after 13s
azurerm_network_security_group.nsg_bot_wvd: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg]
azurerm_subnet_network_security_group_association.assoc_wvd: Destruction complete after 17s
azurerm_network_security_group.nsg_wvd: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg]
azurerm_subnet_network_security_group_association.assoc_internal: Destruction complete after 20s
azurerm_network_security_group.nsg_internal: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg]
azurerm_subnet_route_table_association.route_table["bot_wvd"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m21s elapsed]
azurerm_subnet_route_table_association.route_table["internal"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...net/subnets/mr8-dev-scus-internal-snet, 00m21s elapsed]
azurerm_subnet_route_table_association.route_table["wvd"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...cus-vnet/subnets/mr8-dev-scus-WVD-snet, 00m21s elapsed]
azurerm_virtual_network.main_vnet: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...work/virtualNetworks/mr8-dev-scus-vnet, 00m21s elapsed]
azurerm_subnet_network_security_group_association.assoc_dmz: Still creating... [00m11s elapsed]
azurerm_network_security_group.nsg_internal: Modifications complete after 3s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-internal-nsg]
azurerm_subnet_network_security_group_association.assoc_internal: Creating...
azurerm_network_security_group.nsg_bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...ecurityGroups/mr8-dev-bot-scus-WVD-nsg, 00m10s elapsed]
azurerm_subnet_route_table_association.route_table["wvd"]: Destruction complete after 24s
azurerm_network_security_group.nsg_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...orkSecurityGroups/mr8-dev-scus-wvd-nsg, 00m10s elapsed]
azurerm_network_security_group.nsg_wvd: Modifications complete after 11s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-scus-wvd-nsg]
azurerm_subnet_network_security_group_association.assoc_wvd: Creating...
azurerm_subnet_network_security_group_association.assoc_dmz: Creation complete after 19s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet]
azurerm_subnet_route_table_association.route_table["bot_wvd"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m31s elapsed]
azurerm_subnet_route_table_association.route_table["internal"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...net/subnets/mr8-dev-scus-internal-snet, 00m31s elapsed]
azurerm_virtual_network.main_vnet: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...work/virtualNetworks/mr8-dev-scus-vnet, 00m31s elapsed]
azurerm_subnet_network_security_group_association.assoc_internal: Still creating... [00m10s elapsed]
azurerm_network_security_group.nsg_bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...ecurityGroups/mr8-dev-bot-scus-WVD-nsg, 00m20s elapsed]
azurerm_subnet_network_security_group_association.assoc_internal: Creation complete after 10s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet]
azurerm_subnet_route_table_association.route_table["bot_wvd"]: Destruction complete after 37s
azurerm_subnet_network_security_group_association.assoc_wvd: Still creating... [00m10s elapsed]
azurerm_subnet_route_table_association.route_table["internal"]: Still destroying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...net/subnets/mr8-dev-scus-internal-snet, 00m41s elapsed]
azurerm_virtual_network.main_vnet: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...work/virtualNetworks/mr8-dev-scus-vnet, 00m41s elapsed]
azurerm_subnet_network_security_group_association.assoc_wvd: Creation complete after 14s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-WVD-snet]
azurerm_network_security_group.nsg_bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...ecurityGroups/mr8-dev-bot-scus-WVD-nsg, 00m30s elapsed]
azurerm_subnet_route_table_association.route_table["internal"]: Destruction complete after 47s
azurerm_subnet.bot_wvd: Modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
azurerm_network_security_group.nsg_bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...ecurityGroups/mr8-dev-bot-scus-WVD-nsg, 00m40s elapsed]
azurerm_subnet.bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m10s elapsed]
azurerm_network_security_group.nsg_bot_wvd: Modifications complete after 45s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkSecurityGroups/mr8-dev-bot-scus-WVD-nsg]
azurerm_subnet.bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m20s elapsed]
azurerm_subnet.bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m30s elapsed]
azurerm_subnet.bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m41s elapsed]
azurerm_subnet.bot_wvd: Still modifying... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-...vnet/subnets/mr8-dev-bot-scus-WVD-snet, 00m51s elapsed]
azurerm_subnet.bot_wvd: Modifications complete after 56s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-bot-scus-WVD-snet]
╷
│ Error: executing request: Head "https://ontdevinfraterraform.blob.core.windows.net/tfstate/mr8-dev-rg.terraform.tfstate": dial tcp: lookup ontdevinfraterraform.blob.core.windows.net on 10.255.255.254:53: read udp 10.255.255.254:37904->10.255.255.254:53: i/o timeout
│
│
╵
╷
│ Error: updating Virtual Network (Subscription: "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
│ Resource Group Name: "mr8-dev-rg"
│ Virtual Network Name: "mr8-dev-scus-vnet"): polling after CreateOrUpdate: polling was cancelled: the Azure API returned the following error:
│
│ Status: "Canceled"
│ Code: "CanceledAndSupersededDueToAnotherOperation"
│ Message: "Operation was canceled.\nOperation PutVirtualNetworkOperation (86e6c142-553b-4ef6-bc21-c002c012f9c4) was canceled and superseded by operation PutSubnetOperation (61bd0cca-ed54-4358-8325-42eda91d18c1)."
│ Activity Id: ""
│
│ ---
│
│ API Response:
│
│ ----[start]----
│ {"status":"Canceled","error":{"code":"Canceled","message":"Operation was canceled.","details":[{"code":"CanceledAndSupersededDueToAnotherOperation","message":"Operation PutVirtualNetworkOperation (86e6c142-553b-4ef6-bc21-c002c012f9c4) was canceled and superseded by operation PutSubnetOperation (61bd0cca-ed54-4358-8325-42eda91d18c1)."}]}}
│ -----[end]-----
│
│
│   with azurerm_virtual_network.main_vnet,
│   on networking.tf line 2, in resource "azurerm_virtual_network" "main_vnet":
│    2: resource "azurerm_virtual_network" "main_vnet" {
