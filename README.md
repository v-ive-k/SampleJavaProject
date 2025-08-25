 terraform state show 'azurerm_virtual_machine.vm["dvkib2_rpa01"]' | grep id
    id                    = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01"
    network_interface_ids = [
        "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/dvkib2-rpa01497",
    identity {
        identity_ids = []
        principal_id = "63cc7c8d-966f-4519-b446-b6b8dc644d3b"
        tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502"
        managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/dvkib2-rpa01_datadisk01"
        id        = null
        managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform state show 'azurerm_mssql_virtual_machine.vm["sql1"]' | grep id
No instance found for the given address!

This command requires that the address references one specific instance.
To view the available instances, use "terraform state list". Please modify
the address to reference a specific instance.
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform state show 'azurerm_mssql_virtual_machine.sql_vm["sql1"]' | grep id
    id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01"
    sql_virtual_machine_group_id = null
    virtual_machine_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-rpa01"
