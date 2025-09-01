provide.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.10"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "azurerm" {}
}
# Ont-dev1 provider block
provider "azurerm" {
  features {}
  subscription_id = "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
}

=======================

variable.tf

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
    subnet_id : string
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
      admin_username             = string
      admin_password             = optional(string)
      computer_name              = optional(string)
      admin_password_secret_name = optional(string)

    }))

    # Windows config

    windows_config = optional(object({
      provision_vm_agent        = bool
      enable_automatic_upgrades = bool
    }))
    use_kv_password = optional(bool)
  }))

}

# key vault variables

variable "key_valut_name" {
  type = string
}

variable "key_valut_rg" {
  type = string
}



# variable "new_vms" {
#   type = map(object({
#     name        = string
#     size        = string
#     nic_key     = string
#     os_disk_key = string
#     image_reference = object({
#       id        = optional(string)
#       publisher = optional(string)
#       offer     = optional(string)
#       sku       = optional(string)
#       version   = optional(string)
#     })
#     os_profiles = object({
#       admin_username = string
#       admin_password = string
#       computer_name  = optional(string)
#     })
#     windows_config = object({
#       provision_vm_agent        = bool
#       enable_automatic_upgrades = bool
#     })
#   }))
#   default = {}
# }




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

====================

passwords.tf

# Filter: only VMs that asked for KV-backed password
locals {
  vms_with_kv_pw = {
    for k, v in var.vms :
    k => v if try(v.use_kv_password, false)
  }
}

# Strong random password per VM (only for opted-in VMs)
resource "random_password" "vm_pw" {
  for_each = local.vms_with_kv_pw

  length           = 20
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "_%@#&-+!?"
}

# Store those passwords in Key Vault
resource "azurerm_key_vault_secret" "vm_pw" {
  for_each = local.vms_with_kv_pw

  name = coalesce(
    try(each.value.os_profiles.admin_password_secret_name, null),
    "localadmin-${each.key}"
  )
  value        = random_password.vm_pw[each.key].result
  key_vault_id = data.azurerm_key_vault.vm_passwords.id
  content_type = "auto-generated by Terraform"
  tags         = var.global_tags
}

==========================================

kv.tf

data "azurerm_key_vault" "vm_passwords" {
  name                = var.key_valut_name
  resource_group_name = var.key_valut_rg
}

=======================================

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
      admin_password = (
  try(length(trimspace(each.value.os_profiles.admin_password)) > 0, false) ? each.value.os_profiles.admin_password : random_password.new_vm_pw[each.key].result)
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
#
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



















