terraform import azurerm_network_interface.nic_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/networkInterfaces/nic-BUILDCONTROLLER-00-test"


terraform import azurerm_managed_disk.osdisk_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test"

terraform import azurerm_windows_virtual_machine.vm_buildcontroller \
"/subscriptions/<sub_id>/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/BUILD­CONTROLLER-test"



# vms.tf
resource "azurerm_windows_virtual_machine" "vm_buildcontroller" {
  name                = "BUILDCONTROLLER-test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  size                = "Standard_D2as_v5"              # from state
  network_interface_ids = [
    azurerm_network_interface.nic_buildcontroller.id
  ]

  # Windows VMs usually require these on create, but for imported VMs we don't want diffs.
  # Provide placeholder and ignore changes.
  admin_username = "imported"        # placeholder
  admin_password = "DoNotUse123!"    # placeholder

  os_disk {
    caching              = "ReadWrite"                  # from state
    storage_account_type = "Premium_LRS"                # from state
    # disk_size_gb       = 127                          # only if present in state
  }

  # If state shows an image reference, declare it to avoid drift
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  # If boot diagnostics are enabled:
  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.diag.primary_blob_endpoint
  # }

  tags = var.global_tags

  lifecycle {
    ignore_changes = [
      admin_username,
      admin_password,
      # If the VM was created from a specific version/image or has a plan:
      source_image_reference,
      # Optional: computer_name, timeouts, patch_settings, secret/certificate sets, etc.
      # Add any fields that show noisy diffs in your plan
    ]
  }
}
