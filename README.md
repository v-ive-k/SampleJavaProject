resource "azurerm_mssql_virtual_machine" "sql_vm" {
  for_each            = var.sql_vms
  virtual_machine_id  = azurerm_virtual_machine.vm[each.value.vm_key].id
  sql_license_type    = each.value.license_type # "PAYG" or "AHUB"

  auto_patching {
    day_of_week        = each.value.patch_day
    maintenance_window = each.value.patch_window
    patch_category     = each.value.patch_category
  }

  auto_backup {
    enable                 = each.value.enable_backup
    backup_system_dbs      = each.value.backup_system_dbs
    backup_schedule_type   = each.value.backup_schedule_type
    full_backup_frequency  = each.value.full_backup_frequency
    full_backup_start_hour = each.value.full_backup_start_hour
    full_backup_window_in_hours = each.value.full_backup_window
    retention_period_in_days    = each.value.retention_days
  }
}



==================================================


variable "sql_vms" {
  description = "SQL VM configuration"
  type = map(object({
    vm_key                 = string
    license_type           = string
    patch_day              = string
    patch_window           = number
    patch_category         = string
    enable_backup          = bool
    backup_system_dbs      = bool
    backup_schedule_type   = string
    full_backup_frequency  = string
    full_backup_start_hour = number
    full_backup_window     = number
    retention_days         = number
  }))
}


=======================================
.tfvars

sql_vms = {
  "sql1" = {
    vm_key                 = "dvkib2_app01"   # must match your VM key in var.vms
    license_type           = "PAYG"
    patch_day              = "Sunday"
    patch_window           = 2
    patch_category         = "WindowsMandatoryUpdates"
    enable_backup          = true
    backup_system_dbs      = true
    backup_schedule_type   = "Manual"
    full_backup_frequency  = "Weekly"
    full_backup_start_hour = 2
    full_backup_window     = 2
    retention_days         = 30
  }
  # repeat for other 3 SQL VMs...
}


========================================

terraform import 'azurerm_mssql_virtual_machine.sql_vm["sql1"]' "/subscriptions/<sub-id>/resourceGroups/<rg-name>/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/<sql-vm-name>"


=================================


# azurerm_mssql_virtual_machine.sql_vm["sql1"] must be replaced
-/+ resource "azurerm_mssql_virtual_machine" "sql_vm" {
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/dvkib2-rpa01" -> (known after apply)
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
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/dvkib2-rpa02" -> (known after apply)
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
    }

  # azurerm_network_interface.nic["buildcontroller_test"] will be updated in-place
  ~ resource "azurerm_network_interface" "nic" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"
        name                           = "nic-BUILDCONTROLLER-00-test"
      ~ tags                           = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (15 unchanged attributes hidden)

        # (1 unchanged block hidden)
    }

































