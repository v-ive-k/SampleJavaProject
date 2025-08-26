Variables.tf 

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

# Temp Network Variables
variable "temp_vnet_name" {}
variable "temp_vnet_address_space" {}
variable "temp_dns_servers" {}

# Temp Subnet Varibales
variable "Internal_snet_name" {}
variable "Internal_snet_address_prefix" {}

# Temp NSG Variables
variable "nsg_Internal_name" {}


# NICs Variables
variable "nics" {
  type = map(object({
    name : string
    subnet_id : string
    allocation : string
    private_ip : string
    ip_config_name : optional(string)
    acclerated_networking_enabled : optional(bool)

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
    disk_size_gb         = string
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


# SQL VM Variables
variable "sql_vms" {
  type = map(object({
    vm_key       = string
    license_type = string
  }))
}

==================================
VMs.tf

resource "azurerm_virtual_machine" "vm" {
  for_each              = var.vms
  name                  = each.value.name
  location              = var.location_name
  resource_group_name   = var.rg_name
  vm_size               = each.value.size
  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]
  tags                  = var.global_tags

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
    managed_disk_id   = each.value.os_disk_creation_option == "Attach" ? azurerm_managed_disk.os[each.value.os_disk_key].id : null
    managed_disk_type = var.os_disks[each.value.os_disk_key].storage_account_type
    os_type           = var.os_disks[each.value.os_disk_key].os_type
    disk_size_gb      = var.os_disks[each.value.os_disk_key].disk_size_gb

  }

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

    ]
  }
}

# SQL Machines

resource "azurerm_mssql_virtual_machine" "sql_vm" {
  for_each           = var.sql_vms
  tags               = var.global_tags
  virtual_machine_id = azurerm_virtual_machine.vm[each.value.vm_key].id
  sql_license_type   = each.value.license_type

}



=========================================

nics.tf

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
    subnet_id                     = each.value.subnet_id
  }

  lifecycle {
    ignore_changes = [
      accelerated_networking_enabled,
    ]
  }
}



=====================================


disks.tf

# OS DISKS (imported) 
resource "azurerm_managed_disk" "os" {
  for_each            = var.os_disks
  name                = each.value.name
  location            = var.location_name
  resource_group_name = var.rg_name

  storage_account_type = each.value.storage_account_type
  create_option        = "Restore"
  disk_size_gb         = each.value.disk_size_gb
  os_type              = each.value.os_type
  hyper_v_generation   = each.value.hyper_v_generation

  # We’re tracking existing OS disks; don’t mutate them
  lifecycle {
    ignore_changes = all
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
    ignore_changes = all
  }
}
   

==============================================================================================




# azurerm_managed_disk.os["buildcontroller_test"] must be replaced
-/+ resource "azurerm_managed_disk" "os" {
      ~ disk_iops_read_only               = 0 -> (known after apply)
      ~ disk_iops_read_write              = 500 -> (known after apply)
      ~ disk_mbps_read_only               = 0 -> (known after apply)
      ~ disk_mbps_read_write              = 100 -> (known after apply)
      ~ id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/BUILDCONTROLLER-OSdisk-00-test" -> (known after apply)
      + logical_sector_size               = (known after apply)
      ~ max_shares                        = 0 -> (known after apply)
        name                              = "BUILDCONTROLLER-OSdisk-00-test"
      - on_demand_bursting_enabled        = false -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-BUILDCON-BuildCon-6a158948-864b-47cb-841a-0e40f85e7658/bookmark/25ee4005-6918-496e-9206-d5b50b1eb4e8" -> null # forces replacement
      + source_uri                        = (known after apply)
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      ~ tier                              = "P10" -> (known after apply)
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (20 unchanged attributes hidden)
    }

  # azurerm_managed_disk.os["dev_mr8_test"] must be replaced
-/+ resource "azurerm_managed_disk" "os" {
      ~ disk_iops_read_only               = 0 -> (known after apply)
      ~ disk_iops_read_write              = 500 -> (known after apply)
      ~ disk_mbps_read_only               = 0 -> (known after apply)
      ~ disk_mbps_read_write              = 100 -> (known after apply)
      ~ id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DEV-MR8-OSdisk-00-test" -> (known after apply)
      + logical_sector_size               = (known after apply)
      ~ max_shares                        = 0 -> (known after apply)
        name                              = "DEV-MR8-OSdisk-00-test"
      - on_demand_bursting_enabled        = false -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-DEV_MR8-DEV_MR8_-c9b456a9-b56c-462d-a11d-6f55e61f3185/bookmark/31935e8c-7ad6-40a5-bba1-b489b3c7dbf5" -> null # forces replacement
      + source_uri                        = (known after apply)
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      + tier                              = (known after apply)
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (20 unchanged attributes hidden)
    }

  # azurerm_managed_disk.os["dev_mrfile_test"] must be replaced
-/+ resource "azurerm_managed_disk" "os" {
      ~ disk_iops_read_only               = 0 -> (known after apply)
      ~ disk_iops_read_write              = 240 -> (known after apply)
      ~ disk_mbps_read_only               = 0 -> (known after apply)
      ~ disk_mbps_read_write              = 50 -> (known after apply)
      ~ id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DEV-MRFILE-OSdisk-00-test" -> (known after apply)
      + logical_sector_size               = (known after apply)
      ~ max_shares                        = 0 -> (known after apply)
        name                              = "DEV-MRFILE-OSdisk-00-test"
      - on_demand_bursting_enabled        = false -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-DEV_MRFI-DEV_MRFI-7739ff6d-d599-4ad7-97b2-7dbd87e7800c/bookmark/3f28c5c4-1ea4-4456-9e2b-a5e7d598202d" -> null # forces replacement
      + source_uri                        = (known after apply)
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      ~ tier                              = "P6" -> (known after apply)
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (20 unchanged attributes hidden)
    }

  # azurerm_managed_disk.os["dev_web_2012r2_test"] must be replaced
-/+ resource "azurerm_managed_disk" "os" {
      ~ disk_iops_read_only               = 0 -> (known after apply)
      ~ disk_iops_read_write              = 500 -> (known after apply)
      ~ disk_mbps_read_only               = 0 -> (known after apply)
      ~ disk_mbps_read_write              = 100 -> (known after apply)
      ~ id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DEV-WEB-2012r2-OSdisk-00-test" -> (known after apply)
      + logical_sector_size               = (known after apply)
      ~ max_shares                        = 0 -> (known after apply)
        name                              = "DEV-WEB-2012r2-OSdisk-00-test"
      - on_demand_bursting_enabled        = false -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-DEV_WEB_-DEV_WEB_-4a44cc59-6f14-42dd-b21d-1148188d90a9/bookmark/3b853025-1e04-4b4f-a15c-2fc9bd401938" -> null # forces replacement
      + source_uri                        = (known after apply)
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      ~ tier                              = "P10" -> (known after apply)
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (20 unchanged attributes hidden)
    }

  # azurerm_managed_disk.os["dockerbuild_test"] must be replaced
-/+ resource "azurerm_managed_disk" "os" {
      ~ disk_iops_read_only               = 0 -> (known after apply)
      ~ disk_iops_read_write              = 1100 -> (known after apply)
      ~ disk_mbps_read_only               = 0 -> (known after apply)
      ~ disk_mbps_read_write              = 125 -> (known after apply)
      ~ id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DOCKERBUILD-OSdisk-00-test" -> (known after apply)
      + logical_sector_size               = (known after apply)
      ~ max_shares                        = 0 -> (known after apply)
        name                              = "DOCKERBUILD-OSdisk-00-test"
      - on_demand_bursting_enabled        = false -> null
      - source_resource_id                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/asrseeddisk-DOCKERBU-DOCKERBU-bf4e3354-c4e3-4f7d-ab48-d85054ff6f0b/bookmark/5a56e035-95a6-44ac-acd3-0d4dfdc3d7c1" -> null # forces replacement
      + source_uri                        = (known after apply)
      - tags                              = {
          - "AzHydration-ManagedDisk-CreatedBy" = "Azure Site Recovery"
        } -> null
      ~ tier                              = "P15" -> (known after apply)
      - trusted_launch_enabled            = false -> null
      - upload_size_bytes                 = 0 -> null
        # (20 unchanged attributes hidden)
    }


---------------------------------------------------------------


for_each = {
    for k, v in var.os_disks : k => v
    if lookup(var.vms[k], "os_disk_creation_option", "Attach") == "Attach"
  }




============================================================================

server.tf

# This is where MR8 servers are created.  There is additional VMs for AVD pools in the avd.tf

# Proximity Placement Group
resource "azurerm_proximity_placement_group" "mr8_staging_ppg" {
  name                = var.mr8_staging_ppg_name
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allowed_vm_sizes    = ["Standard_B2ms", "Standard_B8ms"]

  tags = var.global_tags
}

# Network interfaces
resource "azurerm_network_interface" "vm-nics" {
  for_each = { for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine }

  name                = "${each.value.name}-nic"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name = "${each.value.name}-nic-ip"
    subnet_id                     = each.value.dmz == true ? azurerm_subnet.dmz_subnet.id : azurerm_subnet.internal_subnet.id
    private_ip_address_allocation = each.value.private_ip_suffix != null ? "Static" : "Dynamic"
    private_ip_address = each.value.private_ip_suffix != null ? cidrhost(each.value.dmz == true ? var.dmz_snet_address_prefix : var.internal_snet_address_prefix, each.value.private_ip_suffix) : null
  }

  dynamic "ip_configuration" {
    iterator = additional_ip
    for_each = {
      for ip_suffix in each.value.additional_private_ip_suffix : index(each.value.additional_private_ip_suffix, ip_suffix) + 1 => ip_suffix
      if ip_suffix != 0
    }
    content {
      name = "${each.value.name}-additional-ip-${additional_ip.key}"
      subnet_id = each.value.dmz == true ? azurerm_subnet.dmz_subnet.id : azurerm_subnet.internal_subnet.id
      private_ip_address_allocation = "Static"
      private_ip_address = cidrhost(each.value.dmz == true ? var.dmz_snet_address_prefix : var.internal_snet_address_prefix, additional_ip.value)
    }
  }
  tags = var.global_tags
}

# Virtual machines
resource "azurerm_windows_virtual_machine" "vms" {
  lifecycle {
    ignore_changes = [
      admin_password,
      identity
    ]
  }
  for_each = { for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine }

  name                         = each.value.name
  resource_group_name          = azurerm_resource_group.main_rg.name
  location                     = azurerm_resource_group.main_rg.location
  size                         = each.value.size
  admin_username               = "ONTAdmin"
  admin_password               = data.azurerm_key_vault_secret.ontadmin.value
  patch_mode                   = each.value.patch_mode
  enable_automatic_updates     = each.value.enable_automatic_updates
  timezone                     = each.value.timezone
  #proximity_placement_group_id = azurerm_proximity_placement_group.mr8-staging-ppg.id

  network_interface_ids = [
    azurerm_network_interface.vm-nics[each.value.name].id
  ]

  os_disk {
    name                 = "${each.value.name}-disk-os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 128
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
  for_each = { for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine if virtual_machine.dmz  != true }
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

resource "azurerm_managed_disk" "vm_extra_disk" {
  for_each = var.extra_disk.data_disks
  name                 = "${var.extra_disk.server_name}-${each.value.name}"
  location             = azurerm_resource_group.main_rg.location
  resource_group_name  = azurerm_resource_group.main_rg.name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
   tags = var.global_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "extra_disk_attach" {
  for_each = var.extra_disk.data_disks
  managed_disk_id    = azurerm_managed_disk.vm_extra_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vms[var.extra_disk.server_name].id
  lun                = each.value.lun
  caching            = each.value.caching
}

# Create disks for SQL and attach to VM
resource "azurerm_managed_disk" "vm-sql-disks" {
  for_each = var.sql_settings.data_disks

  name                 = "${var.sql_settings.server_name}-disk-${each.value.name}"
  resource_group_name  = azurerm_resource_group.main_rg.name
  location             = azurerm_resource_group.main_rg.location
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb

  tags = var.global_tags
}


resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
  for_each = var.sql_settings.data_disks

  managed_disk_id    = azurerm_managed_disk.vm-sql-disks[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.vms[var.sql_settings.server_name].id
  lun                = each.value.lun
  caching            = each.value.caching
}

# SQL server VM
resource "azurerm_mssql_virtual_machine" "vm-sql" {
  depends_on = [azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach]

  virtual_machine_id    = azurerm_windows_virtual_machine.vms[var.sql_settings.server_name].id
  sql_license_type      = var.sql_settings.sql_license_type
  sql_connectivity_port = var.sql_settings.sql_connectivity_port
  sql_connectivity_type = var.sql_settings.sql_connectivity_type

  storage_configuration {
    disk_type             = var.sql_settings.storage_disk_type
    storage_workload_type = var.sql_settings.storage_workload_type
    data_settings {
      default_file_path = var.sql_settings.data_disks.data.default_file_path
      luns              = [var.sql_settings.data_disks.data.lun]
    }
    dynamic "log_settings" {
  for_each = contains(keys(each.value.data_disks), "logs") ? [1] : []
  content {
    default_file_path = each.value.data_disks.logs.default_file_path
    luns              = [each.value.data_disks.logs.lun]
  }
}
    temp_db_settings {
      default_file_path = var.sql_settings.data_disks.tempdb.default_file_path
      luns              = [var.sql_settings.data_disks.tempdb.lun]
    }
  }
}


======================================

sql_settings = {
  server_name = "STKIB2-SQL01"
  data_disks = {
    "data" = {
      name                 = "SQLVMDATA01",
      storage_account_type = "Premium_LRS",
      create_option        = "Empty",
      disk_size_gb         = 1024,
      lun                  = 1,
      default_file_path    = "F:\\SQLDATA",
      caching              = "ReadOnly",
    }
    "logs" = {
      name                 = "SQLVMLOGS",
      storage_account_type = "Standard_LRS",
      create_option        = "Empty",
      disk_size_gb         = 128,
      lun                  = 2,
      default_file_path    = "G:\\SQLLOG",
      caching              = "None",
    }
    "tempdb" = {
      name                 = "SQLVMTEMPDB",
      storage_account_type = "Premium_LRS",
      create_option        = "Empty",
      disk_size_gb         = 128,
      lun                  = 0,
      default_file_path    = "H:\\SQLTEMP",
      caching              = "ReadOnly",
    }
  }
  
  
}

===================================

# Global variables
variable "location_name" {}
variable "global_tags" {}

# Resource Group Variables
variable "rg_name" {}

# Networking Variables
variable "main_vnet_name" {}
variable "main_vnet_address_space" {}
variable "avd_snet_address_prefix" {}
variable "avd_snet_name" {}
variable "internal_snet_address_prefix" {}
variable "internal_snet_name" {}
variable "dmz_snet_address_prefix" {}
variable "dmz_snet_name" {}
variable "main_dns_servers" {}
variable "infra_snet_name" {}
variable "infra_snet_address_prefix" {}

#Network Security Group Variables
variable "avd_nsg_name" {}
variable "internal_nsg_name" {}
variable "dmz_nsg_name" {}

# AVD workspace variables
variable "ws_friendly_name" {}
variable "ws_name" {}

# Start networking-nsg-rules.tf variables
variable "server_names" {
  description = "Names assigned to servers. These may need to be changed between environments (dev, staging, prod, etc)"
  type        = map(string)
}
variable "net_services" {
  description = "Map of network services associated with port numbers. Protocol is to help user determine how to set up rule. It is not used otherwise yet."
  type = map(object({
    protocol = string
    port     = list(string)
  }))
}

#Pool01 variables
variable "hostpool01_count" {}
variable "hostpool01_name" {}
variable "hostpool01_friendly" {}
variable "hostpool01_description" {}
variable "hostpool01_MaxSessions" {}
variable "hostpool01_RDPProperties" {}
variable "hostpool01_prefix" {}
variable "hostpool01_host_size" {}
variable "hostpool01_timezone" {}

# Domain join variables
variable "domain_name" {}
variable "domain_user_upn" {}
variable "domain_ou_path" {}

# Proximity Placement Group
variable "mr8_staging_ppg_name" {}
variable "allowed_vm_sizes" {}

# virtual machines
variable "virtual_machines" {
  type = list(object({
    name = string,
    size = string,
    source_image = optional(object({
      publisher = string,
      offer     = string,
      sku       = string,
      version   = string,
      }), {
      publisher = "MicrosoftWindowsServer",
      offer     = "WindowsServer",
      sku       = "2022-Datacenter",
      version   = "latest",
    })
    timezone                     = optional(string, "Central Standard Time"),
    patch_mode                   = optional(string, "Manual"),
    enable_automatic_updates     = optional(bool, false),
    auto_shutdown_enabled        = optional(bool, false),
    auto_shutdown_time           = optional(number),
    dmz                          = optional(bool, false),
    private_ip_suffix            = optional(number, null),
    additional_private_ip_suffix = optional(list(number), [0]),
    ou_path                      = optional(string),

  }))
}

variable "extra_disk" {
  type = object({
    server_name           = string,
    data_disks = map(object({
    name                 = string,
    storage_account_type = string,
    create_option = string,
    disk_size_gb         = number,
      lun                  = number,
      caching              = string,
     })),
  })
}
  
variable "sql_settings" {
  type = map(object({
    server_name           = string,
    sql_license_type      = optional(string, "PAYG"),
    sql_connectivity_port = optional(number, 1433),
    sql_connectivity_type = optional(string, "PRIVATE"),
    storage_disk_type     = optional(string, "NEW"),
    storage_workload_type = optional(string, "GENERAL"),
    data_disks = map(object({
      name                 = string,
      storage_account_type = string,
      create_option        = string,
      disk_size_gb         = number,
      lun                  = number,
      default_file_path    = string,
      caching              = string,
    })),
  }))
}




















