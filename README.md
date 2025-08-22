terraform import azurerm_network_interface.nic_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"


terraform import azurerm_managed_disk.osdisk_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"

terraform import azurerm_windows_virtual_machine.vm_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILD­CONTROLLER-test"



│ Error: Invalid combination of arguments
│
│   with azurerm_windows_virtual_machine.vm_buildcontroller,
│   on vms.tf line 2, in resource "azurerm_windows_virtual_machine" "vm_buildcontroller":
│    2: resource "azurerm_windows_virtual_machine" "vm_buildcontroller" {
│
│ "source_image_id": one of `source_image_id,source_image_reference` must be specified
╵
╷
│ Error: Invalid combination of arguments
│
│   with azurerm_windows_virtual_machine.vm_buildcontroller,
│   on vms.tf line 2, in resource "azurerm_windows_virtual_machine" "vm_buildcontroller":
│    2: resource "azurerm_windows_virtual_machine" "vm_buildcontroller" {
│
│ "source_image_reference": one of `source_image_id,source_image_reference` must be specified
