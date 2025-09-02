disks.tf

# OS DISKS (only for VMs that ATTACH an existing OS disk)
resource "azurerm_managed_disk" "os" {
  # drive from VMs; include only those that Attach
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
  create_option        = "Empty"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}


resource "azurerm_managed_disk" "data" {
  for_each = {
    for pair in flatten([
      for vm, disks in var.data_disks : [
        for d in disks : {
          key   = "${vm}-${d.lun}"
          value = d
        }
      ]
    ]) : pair.key => pair.value
  }

  name                 = each.value.name
  location             = var.location_name
  resource_group_name  = var.rg_name
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  create_option        = "Empty"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

===================================

main.tf

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location_name
  tags     = var.global_tags
}
 =====================

networking.tf

# Create Virtual Network -1
resource "azurerm_virtual_network" "main_vnet" {
  name                = var.main_vnet_name
  location            = var.location_name
  resource_group_name = var.rg_name
  address_space       = var.main_vnet_address_space
  dns_servers         = var.main_dns_servers
  tags                = var.global_tags
}

# Creating Subnets
resource "azurerm_subnet" "internal" {
  name                 = var.internal_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.main_vnet_name
  address_prefixes     = [var.internal_snet_address_prefix]
}

resource "azurerm_subnet" "wvd" {
  name                              = var.wvd_snet_name
  resource_group_name               = var.rg_name
  virtual_network_name              = var.main_vnet_name
  address_prefixes                  = [var.wvd_snet_address_prefix]
  private_endpoint_network_policies = "Enabled"
  service_endpoints                 = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "dmz" {
  name                              = var.dmz_snet_name
  resource_group_name               = var.rg_name
  virtual_network_name              = var.main_vnet_name
  address_prefixes                  = [var.dmz_snet_address_prefix]
  private_endpoint_network_policies = "Enabled"
  service_endpoints                 = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "bot_wvd" {
  name                 = var.bot_wvd_snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.main_vnet_name
  address_prefixes     = [var.bot_wvd_snet_address_prefix]
}



# Network Security Groups
resource "azurerm_network_security_group" "nsg_internal" {
  name                = var.nsg_internal_name
  location            = var.location_name
  resource_group_name = var.rg_name
  tags                = var.global_tags
}

resource "azurerm_network_security_group" "nsg_wvd" {
  name                = var.nsg_wvd_name
  location            = var.location_name
  resource_group_name = var.rg_name
  tags                = var.global_tags
}

resource "azurerm_network_security_group" "nsg_dmz" {
  name                = var.nsg_dmz_name
  location            = var.location_name
  resource_group_name = var.rg_name
  tags                = var.global_tags
}

resource "azurerm_network_security_group" "nsg_bot_wvd" {
  name                = var.nsg_bot_wvd_name
  location            = var.location_name
  resource_group_name = var.rg_name
  tags                = var.global_tags
}

# Association NSG's to subnets
resource "azurerm_subnet_network_security_group_association" "assoc_internal" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg_internal.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_wvd" {
  subnet_id                 = azurerm_subnet.wvd.id
  network_security_group_id = azurerm_network_security_group.nsg_wvd.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_dmz" {
  subnet_id                 = azurerm_subnet.dmz.id
  network_security_group_id = azurerm_network_security_group.nsg_dmz.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_bot_wvd" {
  subnet_id                 = azurerm_subnet.bot_wvd.id
  network_security_group_id = azurerm_network_security_group.nsg_bot_wvd.id
}

==================

nics.tf


locals {
  subnet_ids = {
    internal = azurerm_subnet.internal.id
    wvd      = azurerm_subnet.wvd.id
    dmz      = azurerm_subnet.dmz.id
    bot_wvd  = azurerm_subnet.bot_wvd.id
  }
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.nics
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name
  tags                = var.global_tags

  ip_configuration {
    name                          = coalesce(each.value.ip_config_name, "${each.value.name}-ipConfig")
    primary                       = true
    private_ip_address_allocation = each.value.allocation # "Dynamic" or "Static"
    private_ip_address            = each.value.allocation == "Static" ? each.value.private_ip : null
    private_ip_address_version    = "IPv4"
    subnet_id                     = local.subnet_ids[each.value.subnet_key]
  }

  lifecycle {
    ignore_changes = [
      accelerated_networking_enabled,
    ]
  }
}


=====================================


.tfvars

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
    subnet_key     = "internal"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.4"
    ip_config_name = "ipconfig"
  },
  "dvkib2_app01" = {
    name           = "dvkib2-app01435"
    subnet_key     = "internal"
    allocation     = "Dynamic"
    private_ip     = "10.239.64.6"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_def01" = {
    name           = "dvkib2-def01508"
    subnet_key     = "internal"
    allocation     = "Static"
    private_ip     = "10.239.64.60"
    ip_config_name = "ipconfig1"
  },
  # "dvkib2_rpa01" = {
  #   name           = "dvkib2-rpa01497"
  #   subnet_key      = "internal"
  #   allocation     = "Dynamic"
  #   private_ip     = "10.239.64.7"
  #   ip_config_name = "ipconfig1"
  # },
  # "dvkib2_rpa02" = {
  #   name           = "dvkib2-rpa02608"
  #   subnet_key      = "internal"
  #   allocation     = "Dynamic"
  #   private_ip     = "10.239.64.10"
  #   ip_config_name = "ipconfig1"
  # },
  "dvkib2_web01" = {
    name           = "dvkib2-web01177"
    subnet_key     = "dmz"
    allocation     = "Static"
    private_ip     = "10.239.65.17"
    ip_config_name = "ipconfig1"
  },
  "dvkib2_web02" = {
    name           = "dvkib2-web02469"
    subnet_key     = "dmz"
    allocation     = "Static"
    private_ip     = "10.239.65.18"
    ip_config_name = "ipconfig1"
  },
  "dvwgb2_ftp01" = {
    name           = "dvwgb2-ftp01208"
    subnet_key     = "dmz"
    allocation     = "Static"
    private_ip     = "10.239.65.19"
    ip_config_name = "ipconfig1"
  },
  "kib2_nsb01" = {
    name           = "kib2-nsb01216"
    subnet_key     = "internal"
    allocation     = "Static"
    private_ip     = "10.239.64.80"
    ip_config_name = "ipconfig1"
  },
  # "STKIB2-SQL01" = {
  #   name       = "STKIB2-SQL01-nic"
  #   subnet_key      = "internal"
  #   allocation = "Static"
  #   private_ip = "10.10.1.50"
  # }
}

# Data Disks

data_disks = {
  # "dvkib2_rpa01" = [
  #   {
  #     name                 = "DVKIB2-RPA01_DataDisk01"
  #     disk_size_gb         = 512
  #     storage_account_type = "Premium_LRS"
  #     lun                  = 0
  #     caching              = "ReadOnly"
  #   }
  # ],
  # "dvkib2_rpa02" = [
  #   {
  #     name                 = "DVKIB2-RPA02_DataDisk_0"
  #     disk_size_gb         = 512
  #     storage_account_type = "Premium_LRS"
  #     lun                  = 0
  #     caching              = "ReadOnly"
  #   }
  # ],

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
  # "dvkib2_rpa01" = {
  #   name                 = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
  #   disk_size_gb         = 127
  #   storage_account_type = "Premium_LRS"
  #   os_type              = "Windows"
  #   hyper_v_generation   = "V2"
  # },
  # "dvkib2_rpa02" = {
  #   name                 = "DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700"
  #   disk_size_gb         = 256
  #   storage_account_type = "Premium_LRS"
  #   os_type              = "Windows"
  #   hyper_v_generation   = "V2"
  # },
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
  # "STKIB2-SQL01" = {
  #   name                 = "STKIB2-SQL01-OsDisk"
  #   disk_size_gb         = 127
  #   storage_account_type = "Premium_LRS"
  #   os_type              = "Windows"
  #   hyper_v_generation   = "V2"
  # }

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
    os_disk_creation_option = "FromImage"
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
  # "dvkib2_rpa01" = {
  #   name                    = "DVKIB2-RPA01"
  #   size                    = "Standard_B8s_v2"
  #   nic_key                 = "dvkib2_rpa01"
  #   os_disk_key             = "dvkib2_rpa01"
  #   boot_diag_uri           = ""
  #   identity_type           = "SystemAssigned"
  #   os_disk_creation_option = "FromImage"
  #   image_reference = {
  #     offer     = "WindowsServer"
  #     publisher = "MicrosoftWindowsServer"
  #     sku       = "2019-datacenter-gensecond"
  #     version   = "latest"
  #   }
  #   os_profiles = {
  #     admin_username = "ontadmin"
  #     admin_password = ""
  #     computer_name  = "DVKIB2-RPA01"
  #   }
  #   windows_config = {
  #     provision_vm_agent        = true
  #     enable_automatic_upgrades = true
  #   }
  # },
  # "dvkib2_rpa02" = {
  #   name                    = "DVKIB2-RPA02"
  #   size                    = "Standard_B16s_v2"
  #   nic_key                 = "dvkib2_rpa02"
  #   os_disk_key             = "dvkib2_rpa02"
  #   boot_diag_uri           = ""
  #   identity_type           = "SystemAssigned"
  #   os_disk_creation_option = "FromImage"
  #   image_reference = {
  #     offer     = "WindowsServer"
  #     publisher = "MicrosoftWindowsServer"
  #     sku       = "2019-datacenter-gensecond"
  #     version   = "latest"
  #   }
  #   os_profiles = {
  #     admin_username = "ontadmin"
  #     admin_password = ""
  #     computer_name  = "DVKIB2-RPA02"
  #   }
  #   windows_config = {
  #     provision_vm_agent        = true
  #     enable_automatic_upgrades = true
  #   }
  # },
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
  # "STKIB2-SQL01" = {
  #   name                    = "STKIB2-SQL01"
  #   size                    = "Standard_D2s_v5"
  #   nic_key                 = "STKIB2-SQL01"
  #   os_disk_key             = "STKIB2-SQL01"
  #   boot_diag_uri           = ""
  #   identity_type           = "SystemAssigned"
  #   os_disk_creation_option = "FromImage"

  #   image_reference = {
  #     publisher = "MicrosoftWindowsServer"
  #     offer     = "WindowsServer"
  #     sku       = "2019-Datacenter"
  #     version   = "latest"
  #   }

  #   os_profiles = {
  #     admin_username = "localadmin"
  #     admin_password = "CHANGE_ME_Str0ng!" # use a strong secret
  #     computer_name  = "DVKIB2-APP02"
  #   }

  #   windows_config = {
  #     provision_vm_agent        = true
  #     enable_automatic_upgrades = true
  #   }
  # }

}

# SQL Vms


# sql_settings = {
#   sql01 = {
#     server_name = "STKIB2-SQL01"
#     data_disks = {
#       data = {
#         name                 = "SQLVMDATA01",
#         storage_account_type = "Premium_LRS",
#         create_option        = "Empty",
#         disk_size_gb         = 1024,
#         lun                  = 1,
#         default_file_path    = "F:\\SQLDATA",
#         caching              = "ReadOnly",
#       }
#       logs = {
#         name                 = "SQLVMLOGS",
#         storage_account_type = "Standard_LRS",
#         create_option        = "Empty",
#         disk_size_gb         = 128,
#         lun                  = 2,
#         default_file_path    = "G:\\SQLLOG",
#         caching              = "None",
#       }
#       tempdb = {
#         name                 = "SQLVMTEMPDB",
#         storage_account_type = "Premium_LRS",
#         create_option        = "Empty",
#         disk_size_gb         = 128,
#         lun                  = 0,
#         default_file_path    = "H:\\SQLTEMP",
#         caching              = "ReadOnly",
#       }

#     }
#   }
# }

=============


variables.tf

#Global Var
variable "global_tags" {}

# Resource Group Variable
variable "rg_name" {}

# Locatoin Variable
variable "location_name" {}

# Main Networking Variables
variable "main_vnet_name" {}
variable "main_vnet_address_space" {}
variable "main_dns_servers" {}

# Subnet Variables
variable "internal_snet_name" {}
variable "internal_snet_address_prefix" {}
variable "wvd_snet_name" {}
variable "wvd_snet_address_prefix" {}
variable "dmz_snet_name" {}
variable "dmz_snet_address_prefix" {}
variable "bot_wvd_snet_name" {}
variable "bot_wvd_snet_address_prefix" {}

# Network Security Group Variables
variable "nsg_internal_name" {}
variable "nsg_wvd_name" {}
variable "nsg_dmz_name" {}
variable "nsg_bot_wvd_name" {}


# NICs Variables
variable "nics" {
  type = map(object({
    name : string
    subnet_key = optional(string)
    subnet_id : optional(string)
    allocation : string
    private_ip : string
    ip_config_name : optional(string)
    acclerated_networking_enabled : optional(bool)
    boot_diag_uri = optional(string, "")
    identity_type = optional(string, "")

  }))
}

variable "data_disks" {
  type = map(list(object({
    name                 = string
    disk_size_gb         = number
    storage_account_type = string
    lun                  = number
    caching              = string
  })))
  default = {}
}

# DISKs Variables
variable "os_disks" {
  type = map(object({
    name                 = string
    disk_size_gb         = number
    storage_account_type = string
    os_type              = string
    hyper_v_generation   = string

  }))
}

#VMs Variables
variable "vms" {
  type = map(object({
    name                    = string
    size                    = string
    nic_key                 = string
    os_disk_key             = string
    boot_diag_uri           = string
    identity_type           = string
    os_disk_creation_option = string
    managed_disk_id         = optional(string)

    #for image-based VM's
    image_reference = optional(object({
      id        = optional(string)
      offer     = optional(string)
      publisher = optional(string)
      sku       = optional(string)
      version   = optional(string)
    }))

    # Os Profiles
    os_profiles = optional(object({
      admin_username = string
      admin_password = optional(string)
      computer_name  = optional(string)
    }))

    # Windows config

    windows_config = optional(object({
      provision_vm_agent        = bool
      enable_automatic_upgrades = bool
    }))
  }))
}


variable "new_vms" {
  type = map(object({
    name        = string
    size        = string
    nic_key     = string
    os_disk_key = string
    image_reference = object({
      id        = optional(string)
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
      version   = optional(string)
    })
    os_profiles = object({
      admin_username = string
      admin_password = string
      computer_name  = optional(string)
    })
    windows_config = object({
      provision_vm_agent        = bool
      enable_automatic_upgrades = bool
    })
  }))
  default = {}
}




# variable "sql_settings" {
#   type = map(object({
#     server_name           = string,
#     sql_license_type      = optional(string, "PAYG"),
#     sql_connectivity_port = optional(number, 1433),
#     sql_connectivity_type = optional(string, "PRIVATE"),
#     storage_disk_type     = optional(string, "NEW"),
#     storage_workload_type = optional(string, "GENERAL"),
#     data_disks = map(object({
#       name                 = string,
#       storage_account_type = string,
#       create_option        = string,
#       disk_size_gb         = number,
#       lun                  = number,
#       default_file_path    = string,
#       caching              = string,
#     })),
#   }))
# }


=======================

vms.tf


resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vms
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  vm_size               = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
  tags                  = var.global_tags

  delete_os_disk_on_termination    = false
  delete_data_disks_on_termination = false

  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diag_uri != "" ? [1] : []
    content {
      enabled     = true
      storage_uri = each.value.boot_diag_uri
    }
  }

  dynamic "identity" {
    for_each = each.value.identity_type != "" ? [1] : []
    content {
      type = each.value.identity_type
    }
  }


  storage_os_disk {
    name              = var.os_disks[each.value.os_disk_key].name
    caching           = "ReadWrite"
    create_option     = each.value.os_disk_creation_option
    managed_disk_id   = each.value.os_disk_creation_option == "Attach" ? coalesce(lookup(each.value, "managed_disk_id", null), azurerm_managed_disk.os[each.value.os_disk_key].id) : null
    managed_disk_type = var.os_disks[each.value.os_disk_key].storage_account_type
    os_type           = var.os_disks[each.value.os_disk_key].os_type
    disk_size_gb      = var.os_disks[each.value.os_disk_key].disk_size_gb
  }

  # Image fields only when FromImage
  dynamic "storage_image_reference" {
    for_each = each.value.os_disk_creation_option == "FromImage" ? [1] : []
    content {
      id        = lookup(each.value.image_reference, "id", null)
      publisher = lookup(each.value.image_reference, "publisher", null)
      offer     = lookup(each.value.image_reference, "offer", null)
      sku       = lookup(each.value.image_reference, "sku", null)
      version   = lookup(each.value.image_reference, "version", null)
    }
  }

  dynamic "os_profile" {
    for_each = try(each.value.os_profiles, null) != null ? [each.value.os_profiles] : []
    content {
      computer_name  = lookup(os_profile.value, "computer_name", null)
      admin_username = os_profile.value.admin_username
      admin_password = lookup(os_profile.value, "admin_password", null)
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = try(each.value.windows_config, null) != null ? [each.value.windows_config] : []
    content {
      provision_vm_agent        = os_profile_windows_config.value.provision_vm_agent
      enable_automatic_upgrades = os_profile_windows_config.value.enable_automatic_upgrades
    }
  }

  dynamic "storage_data_disk" {
    for_each = lookup(var.data_disks, each.key, [])
    content {
      name              = storage_data_disk.value.name
      lun               = storage_data_disk.value.lun
      disk_size_gb      = storage_data_disk.value.disk_size_gb
      managed_disk_type = storage_data_disk.value.storage_account_type
      caching           = storage_data_disk.value.caching
      create_option     = "Attach"
      managed_disk_id   = azurerm_managed_disk.data["${each.key}-${storage_data_disk.value.lun}"].id
    }
  }

  lifecycle {
    ignore_changes = [
      boot_diagnostics,
      primary_network_interface_id,
      os_profile,
      os_profile_windows_config,
    ]
  }
}

# =====================================================================================
# ########## SQL MACHINES BLOCK ######### COMMENTED OUT FOR NOW ###########
# =====================================================================================
# resource "azurerm_managed_disk" "vm-sql-disks" {
#   for_each = {
#     for combo in flatten([
#       for sql_key, sql in var.sql_settings : [
#         for disk_key, disk in sql.data_disks : {
#           key         = "${sql_key}-${disk_key}"
#           server_name = sql.server_name
#           disk        = disk
#         }
#       ]
#     ]) : combo.key => combo
#   }

#   name                 = "${each.value.server_name}-disk-${each.value.disk.name}"
#   resource_group_name  = var.rg_name
#   location             = var.location_name
#   storage_account_type = each.value.disk.storage_account_type
#   create_option        = each.value.disk.create_option
#   disk_size_gb         = each.value.disk.disk_size_gb
#   tags                 = var.global_tags
# }


# # Attach SQL disks to VMs
# resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
#   for_each = {
#     for combo in flatten([
#       for sql_key, sql in var.sql_settings : [
#         for disk_key, disk in sql.data_disks : {
#           key         = "${sql_key}-${disk_key}"
#           server_name = sql.server_name
#           disk        = disk
#         }
#       ]
#     ]) : combo.key => combo
#   }

#   managed_disk_id    = azurerm_managed_disk.vm-sql-disks[each.key].id
#   virtual_machine_id = azurerm_virtual_machine.vm[each.value.server_name].id
#   lun                = each.value.disk.lun
#   caching            = each.value.disk.caching
# }

# # SQL server VM
# resource "azurerm_mssql_virtual_machine" "vm-sql" {
#   for_each = var.sql_settings

#   virtual_machine_id    = azurerm_virtual_machine.vm[each.value.server_name].id
#   sql_license_type      = each.value.sql_license_type
#   sql_connectivity_port = each.value.sql_connectivity_port
#   sql_connectivity_type = each.value.sql_connectivity_type

#   storage_configuration {
#     disk_type             = each.value.storage_disk_type
#     storage_workload_type = each.value.storage_workload_type
#     data_settings {
#       default_file_path = each.value.data_disks.data.default_file_path
#       luns              = [each.value.data_disks.data.lun]
#     }
#     dynamic "log_settings"  {
#       for_each = try([each.value.data_disk.logs], [])
#       content{
#       default_file_path = log_settings.value.default_file_path
#       luns              = [log_settings.value.logs.lun]
#     }
#     }
#     dynamic "temp_db_settings" {
#       for_each = try([each.value.data_disk.tempdb], [])
#       content{
#       default_file_path = temp_db_settings.value.default_file_path
#       luns              = [temp_db_settings.value.lun]
#     }
#   }
#   }

#   depends_on = [ 
#     azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach 
#     ]
# }



=======================================
======================================
=======================================

data "azurerm_subscription" "primary" {}

# Get the IT Key Vault for passwords
data "azurerm_key_vault" "ONT-IT-KeyVault" {
  provider            = azurerm.prod
  name                = "ONT-IT-KeyVault"
  resource_group_name = "IT-Prod-RG"
}

#Get the ontadmin password to use for vm deployment
data "azurerm_key_vault_secret" "ontadmin" {
  provider     = azurerm.prod
  name         = "ontadmin"
  key_vault_id = data.azurerm_key_vault.ONT-IT-KeyVault.id
}

#Get the keais domain join account
data "azurerm_key_vault_secret" "svc-keaisjoin" {
  provider     = azurerm.prod
  name         = "svc-keaisjoin"
  key_vault_id = data.azurerm_key_vault.ONT-IT-KeyVault.id
}   

================================

# Virtual machines
resource "azurerm_windows_virtual_machine" "vms" {
  lifecycle {
    ignore_changes = [
      admin_password,
      identity
    ]
  }
  for_each = { for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine }

  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  size                     = each.value.size
  admin_username           = "ONTAdmin"
  admin_password           = data.azurerm_key_vault_secret.ontadmin.value
  patch_mode               = each.value.patch_mode
  enable_automatic_updates = each.value.enable_automatic_updates
  timezone                 = each.value.timezone
  #proximity_placement_group_id = azurerm_proximity_placement_group.mr8-staging-ppg.id

  network_interface_ids = [
    azurerm_network_interface.vm-nics[each.value.name].id
  ]

  os_disk {
    name                 = "${each.value.name}-disk-os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 128
  }


  boot_diagnostics {}

  source_image_reference {
    publisher = each.value.source_image.publisher
    offer     = each.value.source_image.offer
    sku       = each.value.source_image.sku
    version   = each.value.source_image.version
  }
  tags = var.global_tags
}

resource "azurerm_virtual_machine_extension" "vms-domain-join" {
  for_each                   = { for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine if virtual_machine.dmz != true }
  name                       = "${each.value.name}-domain-join"
  virtual_machine_id         = azurerm_windows_virtual_machine.vms[each.value.name].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${each.value.ou_path}",
      "User": "${var.domain_user_upn}@${var.domain_name}",
      "Restart": "true",
      "Options": "3"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${data.azurerm_key_vault_secret.svc-keaisjoin.value}"
    }
  PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [
    azurerm_windows_virtual_machine.vms
  ]
}







































