#Resource Group Variales
rg_name       = "mr8-dev-rg"
location_name = "South Central US"

# TAGS!
global_tags = {
  "environment" = "Development"
  "domain"      = "Keais"
  "owner"       = "Greg Johnson"
  "managed by"  = "terraform"

}


# main V-net Variables
main_vnet_name          = "mr8-dev-scus-vnet"
main_vnet_address_space = ["10.239.64.0/22"]
main_dns_servers        = ["10.249.8.4", "10.249.8.5"]

# Main Subnet Variables
internal_snet_name           = "mr8-dev-scus-internal-snet"
internal_snet_address_prefix = "10.239.64.0/24"
wvd_snet_name                = "mr8-dev-scus-WVD-snet"
wvd_snet_address_prefix      = "10.239.66.0/26"
dmz_snet_name                = "mr8-dev-scus-dmz-snet"
dmz_snet_address_prefix      = "10.239.65.0/24"
bot_wvd_snet_name            = "mr8-dev-bot-scus-WVD-snet"
bot_wvd_snet_address_prefix  = "10.239.66.64/26"

# Main NSG Variables
nsg_internal_name = "mr8-dev-scus-internal-nsg"
nsg_wvd_name      = "mr8-dev-scus-wvd-nsg"
nsg_dmz_name      = "mr8-dev-scus-dmz-nsg"
nsg_bot_wvd_name  = "mr8-dev-bot-scus-WVD-nsg"



# Nics
nics = {
  "dvkib2_9" = {
    name           = "dvkib2-9-nic"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.4"
    ip_config_name = "ipconfig"
  },
  "dvkib2_app01" = {
    name           = "dvkib2-app01435"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.6"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_def01" = {
    name           = "dvkib2-def01508"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Static"
    private_ip     = "10.239.64.60"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_rpa01" = {
    name           = "dvkib2-rpa01497"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.7"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_rpa02" = {
    name           = "dvkib2-rpa02608"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.10"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_web01" = {
    name           = "dvkib2-web01177"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
    allocation     = "Static"
    private_ip     = "10.239.65.17"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_web02" = {
    name           = "dvkib2-web02469"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
    allocation     = "Static"
    private_ip     = "10.239.65.18"
    ip_config_name = "ipconfig1"
  },
  "dvwgb2_ftp01" = {
    name           = "dvwgb2-ftp01208"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-dmz-snet"
    allocation     = "Static"
    private_ip     = "10.239.65.19"
    ip_config_name = "ipconfig1"
  },
  "kib2_nsb01" = {
    name           = "kib2-nsb01216"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Static"
    private_ip     = "10.239.64.80"
    ip_config_name = "ipconfig1"
  },
  "qakib2_opg01" = {
    name           = "qakib2-opg01829"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.8"
    ip_config_name = "ipconfig1"
  },
  "app02-nic" = {
    name       = "DVKIB2-APP02-nic"
    subnet_id      = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet/subnets/mr8-dev-scus-internal-snet"
    allocation = "Static"
    private_ip = "10.10.1.50"
  }
}

# Data Disks

data_disks = {
  "dvkib2_rpa01" = [
    {
      name                 = "DVKIB2-RPA01_DataDisk01"
      disk_size_gb         = 512
      storage_account_type = "Premium_LRS"
      lun                  = 0
      caching              = "ReadOnly"
    }
  ],
  "dvkib2_rpa02" = [
    {
      name                 = "DVKIB2-RPA02_DataDisk_0"
      disk_size_gb         = 512
      storage_account_type = "Premium_LRS"
      lun                  = 0
      caching              = "ReadOnly"
    }
  ],
  "app02" = [
    {
      name                 = "DVKIB2-APP02-Data0"
      disk_size_gb         = 256
      storage_account_type = "Premium_LRS"
      lun                  = 0
      caching              = "ReadOnly"
    }
  ]


}

# OS Disks

os_disks = {
  "dvkib2_9" = {
    name                 = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
    disk_size_gb         = 256
    storage_account_type = "StandardSSD_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },
  "dvkib2_app01" = {
    name                 = "DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dvkib2_def01" = {
    name                 = "DVKIB2-DEF01_osdisk1"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },
  "dvkib2_rpa01" = {
    name                 = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },
  "dvkib2_rpa02" = {
    name                 = "DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700"
    disk_size_gb         = 256
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },
  "dvkib2_web01" = {
    name                 = "DVKIB2-WEB01_OsDisk_1_2983fb975b9d45bc806d054ea09c2dd7"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dvkib2_web02" = {
    name                 = "DVKIB2-WEB02_OsDisk_1_c3cb151d066246e88dee0e84a975e5f8"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "dvwgb2_ftp01" = {
    name                 = "DVWGB2-FTP01_OsDisk_1_0c78f25d49004de5ab80fa6a95b15f2a"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "kib2_nsb01" = {
    name                 = "KIB2-NSB01_osdisk1"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },
  "qakib2_opg01" = {
    name                 = "QAKIB2-OPG01_OsDisk_1_2ee33f23ad8f46a3b8950669b134e049"
    disk_size_gb         = 127
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V1"
  },
  "app02-os" = {
    name                 = "DVKIB2-APP02-OsDisk"
    disk_size_gb         = "127"
    storage_account_type = "Premium_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  }

}

# Vms

vms = {
  "dvkib2_9" = {
    name                    = "dvkib2-9"
    size                    = "Standard_D4as_v5"
    nic_key                 = "dvkib2_9"
    os_disk_key             = "dvkib2_9"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "Attach"
    image_reference = {
      id = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1"
    }
    os_profiles = {
      admin_username = "ontadmin"
      admin_password = ""
      computer_name  = "dvkib2-9"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "dvkib2_app01" = {
    name                    = "DVKIB2-APP01"
    size                    = "Standard_D2s_v4"
    nic_key                 = "dvkib2_app01"
    os_disk_key             = "dvkib2_app01"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "DVKIB2-APP01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "dvkib2_def01" = {
    name                    = "DVKIB2-DEF01"
    size                    = "Standard_B2s"
    nic_key                 = "dvkib2_def01"
    os_disk_key             = "dvkib2_def01"
    boot_diag_uri           = ""
    identity_type           = "SystemAssigned"
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-datacenter-gensecond"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "DVKIB2-DEF01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = false
    }
  },
  "dvkib2_rpa01" = {
    name                    = "DVKIB2-RPA01"
    size                    = "Standard_B8s_v2"
    nic_key                 = "dvkib2_rpa01"
    os_disk_key             = "dvkib2_rpa01"
    boot_diag_uri           = ""
    identity_type           = "SystemAssigned"
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-datacenter-gensecond"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ontadmin"
      admin_password = ""
      computer_name  = "DVKIB2-RPA01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "dvkib2_rpa02" = {
    name                    = "DVKIB2-RPA02"
    size                    = "Standard_B16s_v2"
    nic_key                 = "dvkib2_rpa02"
    os_disk_key             = "dvkib2_rpa02"
    boot_diag_uri           = ""
    identity_type           = "SystemAssigned"
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-datacenter-gensecond"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ontadmin"
      admin_password = ""
      computer_name  = "DVKIB2-RPA02"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "dvkib2_web01" = {
    name                    = "DVKIB2-WEB01"
    size                    = "Standard_E2s_v4"
    nic_key                 = "dvkib2_web01"
    os_disk_key             = "dvkib2_web01"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "DVKIB2-WEB01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "dvkib2_web02" = {
    name                    = "DVKIB2-WEB02"
    size                    = "Standard_E2s_v4"
    nic_key                 = "dvkib2_web02"
    os_disk_key             = "dvkib2_web02"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "DVKIB2-WEB02"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "dvwgb2_ftp01" = {
    name                    = "DVWGB2-FTP01"
    size                    = "Standard_D2s_v4"
    nic_key                 = "dvwgb2_ftp01"
    os_disk_key             = "dvwgb2_ftp01"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "DVWGB2-FTP01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  },
  "kib2_nsb01" = {
    name                    = "KIB2-NSB01"
    size                    = "Standard_B4ms"
    nic_key                 = "kib2_nsb01"
    os_disk_key             = "kib2_nsb01"
    boot_diag_uri           = ""
    identity_type           = "SystemAssigned"
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-datacenter-gensecond"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "KIB2-NSB01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = false
    }
  },
  "qakib2_opg01" = {
    name                    = "QAKIB2-OPG01"
    size                    = "Standard_E2s_v4"
    nic_key                 = "qakib2_opg01"
    os_disk_key             = "qakib2_opg01"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "FromImage"
    image_reference = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    os_profiles = {
      admin_username = "ONTAdmin"
      admin_password = ""
      computer_name  = "QAKIB2-OPG01"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = false
    }
  },

}

new_vms = {
   "app02" = {
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
      admin_password = "CHANGE_ME_Str0ng!" # use a strong secret
      computer_name  = "DVKIB2-APP02"
    }

    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }
  }
}

# SQL Vms

sql_vms = {
  "sql1" = {
    vm_key       = "dvkib2_rpa01"
    license_type = "PAYG"
  },
  "sql2" = {
    vm_key       = "dvkib2_rpa02"
    license_type = "PAYG"
  },
}
