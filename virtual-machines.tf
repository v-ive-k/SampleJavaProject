// Dedicated NIC for STINB2-UTLO1
resource "azurerm_network_interface" "stinb2_utlo1_nic" {
  name                = "STINB2-UTLO1-nic"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                          = "STINB2-UTLO1-nic-ip"
    subnet_id                     = azurerm_subnet.internal_snet.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {
    "Migrate Project" = "INT-MigProject-01"
    "domain"          = "intertel"
    "environment"     = "staging"
    "managed by"      = "terraform"
    "owner"           = "Greg Johnson"
    "Offline"         = "No"
  }
}

// New VM resource for STINB2-UTLO1, cloned from ST-UTILSRV01
resource "azurerm_virtual_machine" "stinb2_utlo1" {
  name                = "STINB2-UTLO1"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = "southcentralus"
  vm_size             = "Standard_B2ms"
  proximity_placement_group_id = azurerm_proximity_placement_group.int-stg-ppg.id

  network_interface_ids = [azurerm_network_interface.stinb2_utlo1_nic.id]

  os_profile {
    computer_name  = "STINB2UTLO1"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  storage_os_disk {
    name              = "STINB2-UTLO1-OsDisk-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  license_type = "Windows_Server"

  tags = {
    "Migrate Project" = "INT-MigProject-01"
    "domain"          = "intertel"
    "environment"     = "staging"
    "managed by"      = "terraform"
    "owner"           = "Greg Johnson"
    "Offline"         = "No"
  }
}

// IIS install extension for STINB2-UTLO1
resource "azurerm_virtual_machine_extension" "stinb2_utlo1_iis" {
  name                 = "IIS"
  virtual_machine_id   = azurerm_virtual_machine.stinb2_utlo1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -Command \"Install-WindowsFeature -Name Web-Server\""
    }
  SETTINGS
}

// .NET 8 install extension for STINB2-UTLO1
resource "azurerm_virtual_machine_extension" "stinb2_utlo1_dotnet8" {
  name                 = "DotNet8"
  virtual_machine_id   = azurerm_virtual_machine.stinb2_utlo1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -Command \"Invoke-WebRequest -Uri https://dotnet.microsoft.com/download/dotnet/8.0/windows-runtime -OutFile dotnet-installer.exe; Start-Process .\\dotnet-installer.exe -ArgumentList '/install','/quiet' -Wait\""
    }
  SETTINGS
}

# Proximity Placement Group
resource "azurerm_proximity_placement_group" "int-stg-ppg" {
  name                = "int-stg-ppg"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allowed_vm_sizes    = ["Standard_B2ms", "Standard_B8ms", "Standard_E8s_v5"]

  tags = var.tags
}

# Network interfaces for imported VMs
resource "azurerm_network_interface" "vm-nics" {
  for_each = { for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine }

  name                = "${each.value.name}-nic"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                          = "${each.value.name}-nic-ip"
    subnet_id                     = each.value.dmz == true ? azurerm_subnet.dmz_snet.id : azurerm_subnet.internal_snet.id
    private_ip_address_allocation = each.value.private_ip_suffix != null ? "Static" : "Dynamic"
    private_ip_address            = each.value.private_ip_suffix != null ? cidrhost(each.value.dmz == true ? var.dmz_snet_address_prefix : var.internal_snet_address_prefix, each.value.private_ip_suffix) : null
    primary                       = true
  }

  dynamic "ip_configuration" {
    iterator = additional_ip
    for_each = {
      for ip_suffix in each.value.additional_private_ip_suffix : index(each.value.additional_private_ip_suffix, ip_suffix) + 1 => ip_suffix
      if ip_suffix != 0
    }
    content {
      name                          = "${each.value.name}-additional-ip-${additional_ip.key}"
      subnet_id                     = each.value.dmz == true ? azurerm_subnet.dmz_snet.id : azurerm_subnet.internal_snet.id
      private_ip_address_allocation = "Static"
      private_ip_address            = cidrhost(each.value.dmz == true ? var.dmz_snet_address_prefix : var.internal_snet_address_prefix, additional_ip.value)
    }
  }

  tags = var.tags
}

# Disks for imported virtual machines
resource "azurerm_managed_disk" "imported-disks" {
  for_each = {
    for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
    if virtual_machine.import == true
  }

  name                 = each.value.name == "ST-WEB01" ? "${each.value.name}-OSdisk-01" : "${each.value.name}-OsDisk-01"
  resource_group_name  = azurerm_resource_group.main_rg.name
  location             = azurerm_resource_group.main_rg.location
  create_option        = "Copy"
  source_resource_id   = each.value.import_disk
  storage_account_type = "Premium_LRS"
  hyper_v_generation   = each.value.name == "ST-TFSServer" ? "V1" : "V2"

  tags = var.tags

  lifecycle {
    ignore_changes = [
      os_type
    ]
  }
}

# Imported VMs
resource "azurerm_virtual_machine" "imported-vms" {
  for_each = {
    for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
    if virtual_machine.import == true
  }

  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.main_rg.name
  location              = azurerm_resource_group.main_rg.location
  network_interface_ids = [azurerm_network_interface.vm-nics[each.value.name].id]
  vm_size               = each.value.vm_size

  os_profile {
    computer_name  = each.value.name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  storage_os_disk {
    name              = "${each.value.name}-OsDisk-01"
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_id   = azurerm_managed_disk.imported-disks[each.value.name].id
    managed_disk_type = "Premium_LRS"
  }

  license_type = "Windows_Server"
  tags         = var.tags
}

# SQL Data Disk Attachment
resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
  managed_disk_id    = azurerm_managed_disk.sql_data_disk.id
  virtual_machine_id = azurerm_virtual_machine.imported-vms[var.sql_settings.server_name].id
  lun                = 0
  caching            = "ReadWrite"
}

# SQL server VM
resource "azurerm_mssql_virtual_machine" "vm-sql" {
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach,
    azurerm_virtual_machine.imported-vms
  ]

  virtual_machine_id    = azurerm_virtual_machine.imported-vms[var.sql_settings.server_name].id
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
    log_settings {
      default_file_path = var.sql_settings.data_disks.logs.default_file_path
      luns              = [var.sql_settings.data_disks.logs.lun]
    }
    temp_db_settings {
      default_file_path = var.sql_settings.data_disks.tempdb.default_file_path
      luns              = [var.sql_settings.data_disks.tempdb.lun]
    }
  }
}

# Auto shutdown settings
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm-autoshutdown" {
  for_each = {
    for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
    if virtual_machine.auto_shutdown_enabled
  }

  virtual_machine_id    = azurerm_virtual_machine.imported-vms[each.value.name].id
  location              = azurerm_resource_group.main_rg.location
  enabled               = each.value.auto_shutdown_enabled
  daily_recurrence_time = each.value.auto_shutdown_time
  timezone              = each.value.timezone

  notification_settings {
    enabled = false
  }

  tags = var.tags
}
