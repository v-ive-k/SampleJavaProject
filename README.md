# OS DISKS (only for VMs that ATTACH an existing OS disk)
resource "azurerm_managed_disk" "os" {
  # Build the map from VM -> its os_disk_key, only when creation_option == Attach
  for_each = {
    for vm_key, vm in var.vms :
    vm.os_disk_key => var.os_disks[vm.os_disk_key]
    if lookup(vm, "os_disk_creation_option", "Attach") == "Attach" && contains(keys(var.os_disks), vm.os_disk_key)
  }

  name                 = each.value.name
  location             = var.location_name
  resource_group_name  = var.rg_name
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  os_type              = each.value.os_type
  hyper_v_generation   = each.value.hyper_v_generation

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}


resource "azurerm_managed_disk" "data" {
  for_each = {
    for pair in flatten([
      for vm, disks in var.data_disks : [
        for index, disk in disks : {
          key   = "${vm}-${index}"
          value = disk
        }
      ]
    ]) : pair.key => pair.value
  }

  name                 = each.value.name
  location             = var.location_name
  resource_group_name  = var.rg_name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb

  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}
   
