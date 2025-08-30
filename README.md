https://us06web.zoom.us/j/3478514167?pwd=z1sOvduCbTTjb6xbtS3LxQWcVykLnE.1


terraform import 'azurerm_managed_disk.os["dvkib2_9"]' /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec


# dvkib2-9
terraform import 'azurerm_virtual_machine.vm["dvkib2_9"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-9

# DVKIB2-APP01
terraform import 'azurerm_virtual_machine.vm["dvkib2_app01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-APP01

# DVKIB2-DEF01
terraform import 'azurerm_virtual_machine.vm["dvkib2_def01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-DEF01

# DVKIB2-RPA01
terraform import 'azurerm_virtual_machine.vm["dvkib2_rpa01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01

# DVKIB2-RPA02
terraform import 'azurerm_virtual_machine.vm["dvkib2_rpa02"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02

# DVKIB2-WEB01
terraform import 'azurerm_virtual_machine.vm["dvkib2_web01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB01

# DVKIB2-WEB02
terraform import 'azurerm_virtual_machine.vm["dvkib2_web02"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB02

# DVWGB2-FTP01
terraform import 'azurerm_virtual_machine.vm["dvwgb2_ftp01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVWGB2-FTP01

# KIB2-NSB01
terraform import 'azurerm_virtual_machine.vm["kib2_nsb01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KIB2-NSB01

# QAKIB2-OPG01
terraform import 'azurerm_virtual_machine.vm["qakib2_opg01"]' \
/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/QAKIB2-OPG01
