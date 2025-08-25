
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform import 'azurerm_mssql_virtual_machine.sql_vm["sql1"]' /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02e
e481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01
azurerm_mssql_virtual_machine.sql_vm["sql1"]: Importing from ID "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01"...
azurerm_mssql_virtual_machine.sql_vm["sql1"]: Import prepared!
  Prepared azurerm_mssql_virtual_machine for import
azurerm_mssql_virtual_machine.sql_vm["sql1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ terraform state show 'azurerm_mssql_virtual_machine.sql_vm["sql1"]'
# azurerm_mssql_virtual_machine.sql_vm["sql1"]:
resource "azurerm_mssql_virtual_machine" "sql_vm" {
    id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01"
    sql_license_type             = "PAYG"
    sql_virtual_machine_group_id = null
    tags                         = {}
    virtual_machine_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-rpa01"
}
