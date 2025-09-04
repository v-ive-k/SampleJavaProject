
# ↓ paste inside the nics map
"dvkib2_mrfl01" = {
  name           = "dvkib2-mrfl01-nic"
  subnet_key     = "internal"     # mr8-dev-scus-internal-snet
  allocation     = "Dynamic"      # use Dynamic to avoid IP collisions
  private_ip     = ""             # leave blank for Dynamic
  ip_config_name = "ipconfig1"
}



# ↓ paste inside the os_disks map
"dvkib2_mrfl01" = {
  name                 = "DVKIB2-MRFL01_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"   # matches 2019/2022 Gen2
}






# ↓ paste inside the vms map
"dvkib2_mrfl01" = {
  name                    = "dvkib2-mrfl01"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkib2_mrfl01"
  os_disk_key             = "dvkib2_mrfl01"
  boot_diag_uri           = ""                 # leave empty unless you have a diag SA
  identity_type           = ""                 # or "SystemAssigned" if you need MSI
  os_disk_creation_option = "FromImage"

  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"    # Gen2 image
    version   = "latest"
  }

  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                        # blank => pulls Key Vault 'ontadmin'
    computer_name  = "DVKIB2-MRFL01"
  }

  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  # domain join (internal subnet → yes)
  join_domain = true
  ou_path     = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
}




data_disks = merge(var.data_disks, {
  "dvkib2_mrfl01" = [
    {
      name                 = "DVKIB2-MRFL01_DataDisk0"
      disk_size_gb         = 128
      storage_account_type = "Premium_LRS"
      lun                  = 0            # first free LUN on this VM
      caching              = "None"       # safe default for mixed read/write
    }
  ]
})
