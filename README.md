# --- Key Vault + Domain (globals) ---
variable "kv_name" {}
variable "kv_rg" {}
variable "kv_secret_admin"       { default = "ontadmin" }
variable "kv_secret_domain_join" { default = "svc-keaisjoin" }

variable "domain_name"   {}
variable "domain_user_upn" { default = "svc-keaisjoin" } # left part, no @domain

# --- Add 2 OPTIONAL fields to each VM object ---
# (So you can keep everything “per-VM” inside your existing var.vms map)
# join_domain defaults to false; ou_path optional.
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

    image_reference = optional(object({
      id        = optional(string)
      offer     = optional(string)
      publisher = optional(string)
      sku       = optional(string)
      version   = optional(string)
    }))

    os_profiles = optional(object({
      admin_username = string
      admin_password = optional(string)
      computer_name  = optional(string)
    }))

    windows_config = optional(object({
      provision_vm_agent        = bool
      enable_automatic_upgrades = bool
    }))

    # >>> NEW optional fields <<<
    join_domain = optional(bool, false)
    ou_path     = optional(string)
  }))
}
============================


# If Key Vault is in the SAME subscription, this is enough.
data "azurerm_key_vault" "it" {
  name                = var.kv_name
  resource_group_name = var.kv_rg
}

data "azurerm_key_vault_secret" "ontadmin" {
  name         = var.kv_secret_admin
  key_vault_id = data.azurerm_key_vault.it.id
}

data "azurerm_key_vault_secret" "svc_keaisjoin" {
  name         = var.kv_secret_domain_join
  key_vault_id = data.azurerm_key_vault.it.id
}
===========================

dynamic "os_profile" {
  for_each = try(each.value.os_profiles, null) != null ? [each.value.os_profiles] : []
  content {
    computer_name  = lookup(os_profile.value, "computer_name", null)
    admin_username = os_profile.value.admin_username

    # For FromImage builds, if admin_password not set in tfvars, pull from KV.
    admin_password = each.value.os_disk_creation_option == "FromImage"
      ? (
          length(trimspace(lookup(os_profile.value, "admin_password", ""))) > 0
          ? os_profile.value.admin_password
          : data.azurerm_key_vault_secret.ontadmin.value
        )
      : null
  }
}

=======================

# Join only VMs where join_domain = true AND ou_path is provided
locals {
  vms_to_join = {
    for k, v in var.vms :
    k => v if try(v.join_domain, false) && length(trimspace(try(v.ou_path, ""))) > 0
  }
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  for_each                   = local.vms_to_join
  name                       = "${each.key}-domain-join"
  virtual_machine_id         = azurerm_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name    = var.domain_name
    OUPath  = each.value.ou_path
    User    = "${var.domain_user_upn}@${var.domain_name}"
    Restart = "true"
    Options = 3
  })

  protected_settings = jsonencode({
    Password = data.azurerm_key_vault_secret.svc_keaisjoin.value
  })

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [azurerm_virtual_machine.vm]
}
=====================

# --- Key Vault / Domain (global) ---
kv_name               = "ONT-IT-KeyVault"
kv_rg                 = "IT-Prod-RG"
kv_secret_admin       = "ontadmin"
kv_secret_domain_join = "svc-keaisjoin"

domain_name     = "keais.example.com"
domain_user_upn = "svc-keaisjoin"
============================

