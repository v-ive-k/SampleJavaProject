terraform import azurerm_network_interface.nic_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"


terraform import azurerm_managed_disk.osdisk_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"

terraform import azurerm_windows_virtual_machine.vm_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILD­CONTROLLER-test"



az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform state show azurerm_virtual_machine.vm_buildcontroller
# azurerm_virtual_machine.vm_buildcontroller:
resource "azurerm_virtual_machine" "vm_buildcontroller" {
    id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILDCONTROLLER-test"
    location                     = "southcentralus"
    name                         = "BUILDCONTROLLER-test"
    network_interface_ids        = [
        "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test",
    ]
    primary_network_interface_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"
    resource_group_name          = "mr8-dev-rg"
    tags                         = {}
    vm_size                      = "Standard_D2as_v5"
    zones                        = []

    boot_diagnostics {
        enabled     = true
        storage_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    }

    identity {
        identity_ids = []
        principal_id = "59349bd0-4d8f-452a-8e07-880d71c29dc3"
        tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502"
        type         = "SystemAssigned"
    }

    storage_os_disk {
        caching                   = "ReadWrite"
        create_option             = "Attach"
        disk_size_gb              = 100
        image_uri                 = null
        managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"
        managed_disk_type         = "Premium_LRS"
        name                      = "BUILDCONTROLLER-OSdisk-00-test"
        os_type                   = "Windows"
        vhd_uri                   = null
        write_accelerator_enabled = false
    }
}
