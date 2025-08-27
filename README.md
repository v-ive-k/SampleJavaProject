# Optionally create a helper local to map VM+LUN -> disk spec
locals {
  data_disk_map = {
    for pair in flatten([
      for vm_key, disks in var.data_disks : [
        for d in disks : {
          key    = "${vm_key}-${d.lun}"
          vm_key = vm_key
          disk   = d
        }
      ]
    ]) : pair.key => pair
  }
}

# Attach data disks to NEW Windows VMs
resource "azurerm_virtual_machine_data_disk_attachment" "win_attach" {
  for_each = {
    # only attachments for VM keys that exist in vm_new_win
    for k, v in local.data_disk_map : k => v
    if contains(keys(azurerm_windows_virtual_machine.vm_new_win), v.vm_key)
  }

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_new_win[each.value.vm_key].id
  lun                = each.value.disk.lun
  caching            = each.value.disk.caching
  create_option      = "Attach"
}
