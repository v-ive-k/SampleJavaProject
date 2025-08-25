  # azurerm_mssql_virtual_machine.sql_vm["sql1"] must be replaced
-/+ resource "azurerm_mssql_virtual_machine" "sql_vm" {
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA01" -> (known after apply)
      + sql_connectivity_port        = 1433
      + sql_connectivity_type        = "PRIVATE"
      ~ tags                         = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      ~ virtual_machine_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-rpa01" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01" # forces replacement
        # (2 unchanged attributes hidden)
    }

  # azurerm_mssql_virtual_machine.sql_vm["sql2"] must be replaced
-/+ resource "azurerm_mssql_virtual_machine" "sql_vm" {
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/DVKIB2-RPA02" -> (known after apply)
      + sql_connectivity_port        = 1433
      + sql_connectivity_type        = "PRIVATE"
      ~ tags                         = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      ~ virtual_machine_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-rpa02" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02" # forces replacement
        # (2 unchanged attributes hidden)
