# NIC (for_each key = "dvkib2_rpa01")
terraform import 'azurerm_network_interface.nic["dvkib2_rpa01"]' \
'/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa01497'

# VM (for_each key = "dvkib2_rpa01")
terraform import 'azurerm_virtual_machine.vm["dvkib2_rpa01"]' \
'/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01'

# Data disk (for_each key = "dvkib2_rpa01-0")
# Use the exact Azure disk name. If your disk is lowercased in Azure (e.g., dvkib2-rpa01_datadisk01),
# change the last segment accordingly AND make sure your data_disks["dvkib2_rpa01"][0].name matches.
terraform import 'azurerm_managed_disk.data["dvkib2_rpa01-0"]' \
'/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA01_DataDisk01'



--------------------------


# NIC (for_each key = "dvkib2_rpa02")
terraform import 'azurerm_network_interface.nic["dvkib2_rpa02"]' \
'/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa02608'

# VM (for_each key = "dvkib2_rpa02")
terraform import 'azurerm_virtual_machine.vm["dvkib2_rpa02"]' \
'/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02'

# Data disk (for_each key = "dvkib2_rpa02-0")
terraform import 'azurerm_managed_disk.data["dvkib2_rpa02-0"]' \
'/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA02_DataDisk_0'

