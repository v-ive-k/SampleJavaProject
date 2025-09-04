"dvkiwgb2_web03" = {
  name           = "dvkiwgb2-web03-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web04" = {
  name           = "dvkiwgb2-web04-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web05" = {
  name           = "dvkiwgb2-web05-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkib2_dts01" = {
  name           = "dvkib2-dts01-nic"
  subnet_key     = "internal"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
}








"dvkiwgb2_web03" = {
  name                 = "DVKIWGB2-WEB03_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web04" = {
  name                 = "DVKIWGB2-WEB04_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web05" = {
  name                 = "DVKIWGB2-WEB05_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkib2_dts01" = {
  name                 = "DVKIB2-DTS01_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
}







"dvkiwgb2_web03" = {
  name                    = "dvkiwgb2-web03"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web03"
  os_disk_key             = "dvkiwgb2_web03"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← pulls from KV 'ontadmin'
    computer_name  = "DVKIWGB2-WEB03"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # DMZ: usually NOT domain joined → omit join_domain
},

"dvkiwgb2_web04" = {
  name                    = "dvkiwgb2-web04"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web04"
  os_disk_key             = "dvkiwgb2_web04"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB04"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkiwgb2_web05" = {
  name                    = "dvkiwgb2-web05"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web05"
  os_disk_key             = "dvkiwgb2_web05"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB05"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkib2_dts01" = {
  name                    = "dvkib2-dts01"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkib2_dts01"
  os_disk_key             = "dvkib2_dts01"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← KV 'ontadmin'
    computer_name  = "DVKIB2-DTS01"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # Internal → domain join ON
  join_domain = true
  ou_path     = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
}



=====================================


# 1) Tell WSL to stop auto-generating /etc/resolv.conf
sudo bash -c 'printf "[network]\ngenerateResolvConf = false\n" > /etc/wsl.conf'

# 2) Replace resolv.conf with your DNS servers
sudo rm -f /etc/resolv.conf
sudo bash -c 'cat >/etc/resolv.conf <<EOF
nameserver 10.249.8.4
nameserver 10.249.8.5
options timeout:1 attempts:2
EOF'
