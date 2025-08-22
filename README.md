terraform import azurerm_network_interface.nic_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"


terraform import azurerm_managed_disk.osdisk_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"

terraform import azurerm_windows_virtual_machine.vm_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILD­CONTROLLER-test"



====================

 # azurerm_managed_disk.osdisk_buildcontroller must be replaced
-/+ resource "azurerm_managed_disk" "osdisk_buildcontroller" {
      ~ disk_iops_read_only               = 0 -> (known after apply)
      ~ disk_iops_read_write              = 500 -> (known after apply)
      ~ disk_mbps_read_only               = 0 -> (known after apply)
      ~ disk_mbps_read_write              = 100 -> (known after apply)
      - hyper_v_generation                = "V1" -> null # forces replacement
      ~ id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test" -> (known after apply)
      + logical_sector_size               = (known after apply)
      ~ max_shares                        = 0 -> (known after apply)
        name                              = "BUILDCONTROLLER-OSdisk-00-test"
      - on_demand_bursting_enabled        = false -> null
      - os_type                           = "Windows" -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-BUILDCON-BuildCon-6a158948-864b-47cb-841a-0e40f85e7658/bookmark/25ee4005-6918-496e-9206-d5b50b1eb4e8" -> null # forces replacement
      + source_uri                        = (known after apply)
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      ~ tier                              = "P10" -> (known after apply)
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (18 unchanged attributes hidden)
