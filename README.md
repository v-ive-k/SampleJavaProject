# Turn on creation of new VMs
enable_new_vms = true

# Standard tags (optional but recommended)
global_tags = {
  environment = "Development"
  domain      = "Keais"
  owner       = "Greg Johnson"
  managed by  = "terraform"
}

# NIC for the new VM (key must match new_vms.app02.nic_key)
nics = merge(var.nics, {
  app02-nic = {
    name       = "DVKIB2-APP02-nic"
    subnet_id  = "/subscriptions/<SUB>/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation = "Static"
    private_ip = "10.10.1.50"
  }
})

# OS disk template (key must match new_vms.app02.os_disk_key)
# NOTE: your os_disks variable uses strings for size; keep that format.
os_disks = merge(var.os_disks, {
  app02-os = {
    name                 = "DVKIB2-APP02-OsDisk"
    disk_size_gb         = "127"
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  }
})

# Define the new VM
new_vms = merge(var.new_vms, {
  app02 = {
    name        = "DVKIB2-APP02"
    size        = "Standard_D2s_v5"
    nic_key     = "app02-nic"
    os_disk_key = "app02-os"

    image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    os_profiles = {
      admin_username = "localadmin"
      admin_password = "CHANGE_ME_Str0ng!"  # use a strong secret
      computer_name  = "DVKIB2-APP02"
    }

    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  }
})

# One data disk (LUN 0) for the new VM
data_disks = merge(var.data_disks, {
  app02 = [
    {
      name                 = "DVKIB2-APP02-Data0"
      disk_size_gb         = 256
      storage_account_type = "Premium_LRS"
      lun                  = 0
      caching              = "ReadOnly"
    }
  ]
})
