AVD.TF

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "stg_workspace" {
  name                = var.stg_workspace
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  friendly_name       = var.stg_workspace_friendly
  description         = var.stg_workspace_description
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags["MessageBody"], tags["MessageTitle"]
    ]
  }
}

# Host Pools Begin
locals {

  # Iterate over each pool inside of var.host_pool, and based on the pool's 'count' value, creates a new list that adds each anticipated VM as 'host'. This is necessary because you cannot combine 'for_each' and 'count' in a single resource definition, so they must be flattened into a single list.
  host_pool_hosts = flatten([
    for host_pool in var.host_pool : [
      for iterator in range(host_pool.count) : merge(host_pool, { host = "${host_pool.name}-${iterator + 1}" })
    ]
  ])

  subnets = {
    mgmt_snet = azurerm_subnet.mgmt_snet
    dmz_snet  = azurerm_subnet.dmz_snet
    avd_snet  = azurerm_subnet.avd_snet
  }

  source_images = {
    AVD-INT-Win10-img      = data.azurerm_shared_image.AVD-INT-Win10-img
    AVD-INT-Mgmt-Win10-img = data.azurerm_shared_image.AVD-INT-Mgmt-Win10-img
  }

}

resource "azurerm_virtual_desktop_host_pool" "pooled_host_pool" {
  for_each = { for pool in var.host_pool : pool.name => pool }

  resource_group_name              = azurerm_resource_group.main_rg.name
  location                         = azurerm_resource_group.main_rg.location
  name                             = each.value.name
  friendly_name                    = each.value.name
  description                      = each.value.description
  type                             = each.value.type
  load_balancer_type               = each.value.load_balancer_type
  personal_desktop_assignment_type = try(each.value.personal_desktop_assignment_type, null)
  maximum_sessions_allowed         = try(each.value.maximum_sessions_allowed, null)
  custom_rdp_properties            = each.value.custom_rdp_properties
  validate_environment             = true
  start_vm_on_connect              = true
  tags                             = merge(var.tags, var.AVD_shared_tags)
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "pooled_host_pool_registration" {
  for_each = { for pool in var.host_pool : pool.name => pool }

  hostpool_id     = azurerm_virtual_desktop_host_pool.pooled_host_pool[each.value.name].id
  expiration_date = timeadd(timestamp(), "720h")

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}

resource "azurerm_virtual_desktop_application_group" "pooled_host_pool_dag" {
  for_each = { for pool in var.host_pool : pool.name => pool }

  resource_group_name          = azurerm_resource_group.main_rg.name
  location                     = azurerm_resource_group.main_rg.location
  host_pool_id                 = azurerm_virtual_desktop_host_pool.pooled_host_pool[each.value.name].id
  name                         = "${each.value.name}-dag"
  friendly_name                = "${each.value.name}-dag"
  default_desktop_display_name = each.value.display_name
  description                  = "Desktop application group for ${each.value.name}"
  type                         = "Desktop"

  depends_on = [
    azurerm_virtual_desktop_host_pool.pooled_host_pool,
    azurerm_virtual_desktop_workspace.stg_workspace
  ]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "pooled_host_pool_dag_ws_connect" {
  for_each = { for pool in var.host_pool : pool.name => pool }

  application_group_id = azurerm_virtual_desktop_application_group.pooled_host_pool_dag[each.value.name].id
  workspace_id         = azurerm_virtual_desktop_workspace.stg_workspace.id
}

resource "azurerm_network_interface" "pooled_host_pool_vm_nics" {
  for_each = { for host in local.host_pool_hosts : host.host => host }

  name                = "${each.value.host}-nic"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  ip_configuration {
    name                          = "${each.value.host}-nic-ip"
    subnet_id                     = lookup(local.subnets, each.value.subnet, "avd_snet").id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
  for_each = { for host in local.host_pool_hosts : host.host => host }

  name                         = each.value.host
  resource_group_name          = azurerm_resource_group.main_rg.name
  location                     = azurerm_resource_group.main_rg.location
  size                         = each.value.size
  admin_username               = "ONTAdmin"
  admin_password               = data.azurerm_key_vault_secret.ontadmin.value
  timezone                     = each.value.timezone
  provision_vm_agent           = true
  proximity_placement_group_id = azurerm_proximity_placement_group.int-stg-ppg.id

  network_interface_ids = [
    azurerm_network_interface.pooled_host_pool_vm_nics[each.value.host].id
  ]

  os_disk {
    name                 = lower(each.value.host)
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_id = lookup(local.source_images, each.value.source_image, "AVD-INT-Win10-img").id

  lifecycle {
    ignore_changes = [
      tags["Offline"]
    ]
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "pooled_host_pool_domain_join" {
  for_each = { for host in local.host_pool_hosts : host.host => host }

  name                       = "${each.value.host}-domain-join"
  virtual_machine_id         = azurerm_windows_virtual_machine.pooled_host_pool_vms[each.value.host].id
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
      "Password": "${data.azurerm_key_vault_secret.intertel-svc-directoryservice.value}"
    }
  PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [
    azurerm_windows_virtual_machine.pooled_host_pool_vms
  ]
}

resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
  for_each = { for host in local.host_pool_hosts : host.host => host }

  name                       = "${each.value.host}-dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.pooled_host_pool_vms[each.value.host].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.pooled_host_pool[each.value.name].name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration[each.value.name].token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.pooled_host_pool_domain_join,
    azurerm_virtual_desktop_host_pool.pooled_host_pool,
    azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration
  ]
}

resource "azurerm_role_assignment" "pooled_host_pool_role_assign" {
  for_each = { for pool in var.host_pool : pool.name => pool }

  scope                = azurerm_virtual_desktop_application_group.pooled_host_pool_dag[each.value.name].id
  role_definition_name = "Desktop Virtualization User"
  principal_id         = each.value.user_group_desktop_virtualization
}
# Pooled Host Pool End

-------------------------------------

DATA-SOURCE.TF

# Get the main ont-dev1 route table
data "azurerm_route_table" "dev-scus-rt" {
  name                = "dev-scus-rt"
  resource_group_name = "NetworkServices-dev-scus-rg"
}

# Get the ont-prod1 IT virtual network
data "azurerm_virtual_network" "IT-Prod-SCUS-VNet" {
  provider            = azurerm.prodcution
  name                = "IT-Prod-SCUS-VNet"
  resource_group_name = "IT-Prod-RG"
}

# Get the ont-prod1 MR8-Prod-RG Virtual Networt
data "azurerm_virtual_network" "MR8-Prod-SCUS-VNet" {
  provider            = azurerm.prodcution
  name                = "MR8-Prod-SCUS-VNet"
  resource_group_name = "MR8-PROD-rg"
}

# Get the ont-dev1 Netowrking virtual network
data "azurerm_virtual_network" "network-dev-scus-vnet" {
  name                = "network-dev-scus-vnet"
  resource_group_name = "networkservices-dev-scus-rg"
}

# Get the Ont-Prod1 int-prod-rg virtual network
data "azurerm_virtual_network" "intertel-prod-scus-vnet" {
  provider            = azurerm.prodcution
  name                = "intertel-prod-scus-vnet"
  resource_group_name = "int-prod-rg"
}

# Get the Ont-Dev1 int-dev-rg virtual network
data "azurerm_virtual_network" "intertel-dev-scus-vnet" {
  #provider = 
  name                = "intertel-dev-scus-vnet"
  resource_group_name = "int-dev-rg"
}

# Get the IT Key Vault for passwords
data "azurerm_key_vault" "ONT-IT-KeyVault" {
  provider            = azurerm.prodcution
  name                = "ONT-IT-KeyVault"
  resource_group_name = "IT-Prod-RG"
}

# Get the passowrd to join AVD hosts and VMs to domain
data "azurerm_key_vault_secret" "intertel-svc-directoryservice" {
  provider     = azurerm.prodcution
  name         = "intertel-svc-directoryservice"
  key_vault_id = data.azurerm_key_vault.ONT-IT-KeyVault.id
}

#Get the ontadmin password to use for vm deployment
data "azurerm_key_vault_secret" "ontadmin" {
  provider     = azurerm.prodcution
  name         = "ontadmin"
  key_vault_id = data.azurerm_key_vault.ONT-IT-KeyVault.id
}

#Get the AVD Images
data "azurerm_shared_image" "AVD-INT-Win10-img" {
  provider            = azurerm.prodcution
  name                = "AVD-INT-Win10-img"
  gallery_name        = "Ont_Prod1_scus_scg"
  resource_group_name = "IT-Prod-RG"
}
data "azurerm_shared_image" "AVD-INT-Mgmt-Win10-img" {
  provider            = azurerm.prodcution
  name                = "AVD-INT-Mgmt-Win10-img"
  gallery_name        = "Ont_Prod1_scus_scg"
  resource_group_name = "IT-Prod-RG"
}

#Get the Terraform SP to RecordsX Technologies tenant value
data "azurerm_key_vault_secret" "Terraform-SP" {
  provider     = azurerm.prodcution
  name         = "3f31972c-b59f-480d-b4f3-71d39043b74e"
  key_vault_id = data.azurerm_key_vault.ONT-IT-KeyVault.id
}

# Get the social-prod-rg virtual network
data "azurerm_virtual_network" "social-staging-scus-vnet" {
  provider            = azurerm.RecordsXTenant
  name                = "social-staging-scus-vnet"
  resource_group_name = "social-staging-rg"
}

# Get the Prod Mgmt subnet to use in networking rules
data "azurerm_subnet" "subnet-prod-mgmt" {
  provider             = azurerm.prodcution
  name                 = "intertel-prod-mgmt-scus-snet"
  virtual_network_name = "intertel-prod-scus-vnet"
  resource_group_name  = "int-prod-rg"
}

--------------------------------------

IMPORTS.TF
# This file includes imports of non-Terraform created resources to bring them under Terraform management. These entries can be removed after importing, or left in the file for archive purposes.

# ST-TFSSERVER ------------------------------
## DISK
import {
  to = azurerm_managed_disk.imported-disks["ST-TFSServer"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-TFSServer-OsDisk-01"
}
## NIC
import {
  to = azurerm_network_interface.vm-nics["ST-TFSServer"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/st-tfsserver973"
}
## VM
import {
  to = azurerm_virtual_machine.imported-vms["ST-TFSServer"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-TFSServer"
}

# ST-UTILSRV01 ------------------------------
## DISK
import {
  to = azurerm_managed_disk.imported-disks["ST-UTILSRV01"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-UTILSRV01-OsDisk-01"
}
## NIC
import {
  to = azurerm_network_interface.vm-nics["ST-UTILSRV01"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/st-utilsrv01301"
}
## VM
import {
  to = azurerm_virtual_machine.imported-vms["ST-UTILSRV01"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV01"
}

# ST-UTILSRV03 ------------------------------
## DISK
import {
  to = azurerm_managed_disk.imported-disks["ST-UTILSRV03"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-UTILSRV03-OsDisk-01"
}
## NIC
import {
  to = azurerm_network_interface.vm-nics["ST-UTILSRV03"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/st-utilsrv03919"
}
## VM
import {
  to = azurerm_virtual_machine.imported-vms["ST-UTILSRV03"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV03"
}

# ST-WEB01 ------------------------------
## DISK
import {
  to = azurerm_managed_disk.imported-disks["ST-WEB01"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-WEB01-OSdisk-01"
}
## NIC
import {
  to = azurerm_network_interface.vm-nics["ST-WEB01"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/st-web01849"
}
## VM
import {
  to = azurerm_virtual_machine.imported-vms["ST-WEB01"]
  id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-WEB01"
}

# Importing the migrated VMs into Terraform works, but it will initially give an error when recreating the NICs. It throws the error: "In order to delete the network interface, it must be dissociated from the resource." However it cannot be dissociated without another NIC associated with the VM first. So uncomment the section below and apply. Then go into Azure portal, manually dissociate the old NIC, associate the temp NIC for the VM created below, and apply again. This will fix the NICs. Once finished, comment the below out again and apply a final time to clean up the temp NICs.
# resource "azurerm_network_interface" "temp-vm-nics" {
#   for_each = {
#     for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
#     if virtual_machine.import == true
#   }

#   name                = "${each.value.name}-temp-nic"
#   resource_group_name = azurerm_resource_group.main_rg.name
#   location            = azurerm_resource_group.main_rg.location

#   ip_configuration {
#     name                          = "${each.value.name}-temp-nic-ip"
#     subnet_id                     = each.value.dmz == true ? azurerm_subnet.dmz_snet.id : azurerm_subnet.internal_snet.id
#     private_ip_address_allocation = "Dynamic"
#   }

#   tags = var.tags
# }



---------------------------------------------------------
MAIN.TF

#Resource group create
resource "azurerm_resource_group" "main_rg" {
  name     = "int-staging-rg"
  location = "South Central US"
  tags     = var.tags
}

# Assign Resource Group access control
resource "azurerm_role_assignment" "owner_ra" {
  scope                = azurerm_resource_group.main_rg.id
  role_definition_name = "Owner"
  principal_id         = var.rg_owner_group_id
}

resource "azurerm_role_assignment" "contributor_ra" {
  scope                = azurerm_resource_group.main_rg.id
  role_definition_name = "Contributor"
  principal_id         = var.rg_contributor_group_id
}

resource "azurerm_role_assignment" "reader_ra" {
  scope                = azurerm_resource_group.main_rg.id
  role_definition_name = "Reader"
  principal_id         = var.rg_reader_group_id
}


------------------------------------------------------------

MOVED.TF
# 2023-09-28 Moving AVD resources to accommodate for changes to AVD pools (from one to many)
moved {
  from = azurerm_virtual_desktop_host_pool.pooled_host_pool
  to   = azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-Std"]
}
moved {
  from = azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration
  to   = azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-Std"]
}
moved {
  from = azurerm_virtual_desktop_application_group.pooled_host_pool_dag
  to   = azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-Std"]
}
moved {
  from = azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect
  to   = azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-Std"]
}
moved {
  from = azurerm_network_interface.pooled_host_pool_vm_nics[0]
  to   = azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-Std-1"]
}
moved {
  from = azurerm_network_interface.pooled_host_pool_vm_nics[1]
  to   = azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-Std-2"]
}
moved {
  from = azurerm_network_interface.pooled_host_pool_vm_nics[2]
  to   = azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-Std-3"] # NOT Found
}
moved {
  from = azurerm_windows_virtual_machine.pooled_host_pool_vms[0]
  to   = azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-1"]
}
moved {
  from = azurerm_windows_virtual_machine.pooled_host_pool_vms[1]
  to   = azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-2"]
}
moved {
  from = azurerm_windows_virtual_machine.pooled_host_pool_vms[2]
  to   = azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-3"]
}
moved {
  from = azurerm_virtual_machine_extension.pooled_host_pool_domain_join[0]
  to   = azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-Std-1"]
}
moved {
  from = azurerm_virtual_machine_extension.pooled_host_pool_domain_join[1]
  to   = azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-Std-2"]
}
moved {
  from = azurerm_virtual_machine_extension.pooled_host_pool_domain_join[2]
  to   = azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-Std-3"]
}
moved {
  from = azurerm_virtual_machine_extension.pooled_host_pool_dsc[0]
  to   = azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-1"]
}
moved {
  from = azurerm_virtual_machine_extension.pooled_host_pool_dsc[1]
  to   = azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-2"]
}
moved {
  from = azurerm_virtual_machine_extension.pooled_host_pool_dsc[2]
  to   = azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-3"]
}
moved {
  from = azurerm_role_assignment.pooled_host_pool_role_assign
  to   = azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-Std"]
}

--------------------------------------


NETWORKING-CORE.TF

# Create Vitual Network
resource "azurerm_virtual_network" "main_vnet" {
  name                = "intertel-staging-scus-vnet"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  address_space       = var.main_vnet_address_space
  dns_servers         = ["10.249.12.11", "10.249.12.12"]
  tags                = var.tags
}

# Create Network Security Groups
resource "azurerm_network_security_group" "mgmt_nsg" {
  name                = "intertel-staging-mgmt-scus-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "avd_nsg" {
  name                = "intertel-staging-avd-scus-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "dmz_nsg" {
  name                = "intertel-staging-dmz-scus-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "internal_nsg" {
  name                = "intertel-staging-inernal-scus-nsg"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  tags                = var.tags
}

# Create Subnets
resource "azurerm_subnet" "mgmt_snet" {
  name                 = "intertel-staging-mgmt-scus-snet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.mgmt_snet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}
resource "azurerm_subnet" "avd_snet" {
  name                 = "intertel-staging-avd-scus-snet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.avd_snet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "dmz_snet" {
  name                 = "intertel-staging-dmz-scus-snet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.dmz_snet_address_prefix]
}

resource "azurerm_subnet" "internal_snet" {
  name                 = "intertel-staging-internal-scus-snet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = [var.internal_snet_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

# Associate NSGs to subnets
resource "azurerm_subnet_network_security_group_association" "mgmt_nsg_association" {
  subnet_id                 = azurerm_subnet.mgmt_snet.id
  network_security_group_id = azurerm_network_security_group.mgmt_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "avd_nsg_association" {
  subnet_id                 = azurerm_subnet.avd_snet.id
  network_security_group_id = azurerm_network_security_group.avd_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "dmz_nsg_association" {
  subnet_id                 = azurerm_subnet.dmz_snet.id
  network_security_group_id = azurerm_network_security_group.dmz_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "internal_nsg_association" {
  subnet_id                 = azurerm_subnet.internal_snet.id
  network_security_group_id = azurerm_network_security_group.internal_nsg.id
}

# Associate route table to subnets
resource "azurerm_subnet_route_table_association" "mgmt_snet_rt_association" {
  subnet_id      = azurerm_subnet.mgmt_snet.id
  route_table_id = data.azurerm_route_table.dev-scus-rt.id
}

resource "azurerm_subnet_route_table_association" "avd_snet_rt_association" {
  subnet_id      = azurerm_subnet.avd_snet.id
  route_table_id = data.azurerm_route_table.dev-scus-rt.id
}

resource "azurerm_subnet_route_table_association" "dmz_snet_rt_association" {
  subnet_id      = azurerm_subnet.dmz_snet.id
  route_table_id = data.azurerm_route_table.dev-scus-rt.id
}

resource "azurerm_subnet_route_table_association" "internal_snet_rt_association" {
  subnet_id      = azurerm_subnet.internal_snet.id
  route_table_id = data.azurerm_route_table.dev-scus-rt.id
}

# Add peering to it-prod-scus-vnet

resource "azurerm_virtual_network_peering" "main_vnet_it_vnet" {
  name                      = "intertel-staging-scus-vnet-TO-it-prod-scus-vnet"
  resource_group_name       = azurerm_resource_group.main_rg.name
  virtual_network_name      = azurerm_virtual_network.main_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.IT-Prod-SCUS-VNet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

resource "azurerm_virtual_network_peering" "prod_it_vnet_main_vnet" {
  provider                  = azurerm.prodcution
  name                      = "it-prod-scus-vnet-TO-intertel-staging-scus-vnet"
  resource_group_name       = data.azurerm_virtual_network.IT-Prod-SCUS-VNet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.IT-Prod-SCUS-VNet.name
  remote_virtual_network_id = azurerm_virtual_network.main_vnet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

# Add peering to networking-dev-rg

resource "azurerm_virtual_network_peering" "main_vnet_network-dev-scus-vnet" {
  name                      = "intertel-staging-scus-vnet-TO-network-dev-scus-vnet"
  resource_group_name       = azurerm_resource_group.main_rg.name
  virtual_network_name      = azurerm_virtual_network.main_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.network-dev-scus-vnet.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

resource "azurerm_virtual_network_peering" "network-dev-scus-vnet_main_vnet" {
  name                      = "network-dev-scus-vnet-TO-intertel-staging-scus-vnet"
  resource_group_name       = data.azurerm_virtual_network.network-dev-scus-vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.network-dev-scus-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.main_vnet.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

# Add peering to MR8-Prod-SCUS-VNet

resource "azurerm_virtual_network_peering" "main_vnet_MR8-Prod-SCUS-VNet" {
  name                      = "intertel-staging-scus-vnet-TO-MR8-Prod-SCUS-VNet"
  resource_group_name       = azurerm_resource_group.main_rg.name
  virtual_network_name      = azurerm_virtual_network.main_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.MR8-Prod-SCUS-VNet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

resource "azurerm_virtual_network_peering" "MR8-Prod-SCUS-VNet_main_vnet" {
  provider                  = azurerm.prodcution
  name                      = "MR8-Prod-SCUS-VNet-TO-intertel-staging-scus-vnet"
  resource_group_name       = data.azurerm_virtual_network.MR8-Prod-SCUS-VNet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.MR8-Prod-SCUS-VNet.name
  remote_virtual_network_id = azurerm_virtual_network.main_vnet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

# Add peering to intertel-prod-scus-vnet in int-prod-rg
resource "azurerm_virtual_network_peering" "intertel-staging-scus-vnet_TO_intertel-prod-scus-vnet" {
  name                      = "intertel-staging-scus-vnet_TO_intertel-prod-scus-vnet"
  resource_group_name       = azurerm_resource_group.main_rg.name
  virtual_network_name      = azurerm_virtual_network.main_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.intertel-prod-scus-vnet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

resource "azurerm_virtual_network_peering" "intertel-prod-scus-vnet_TO_intertel-staging-scus-vnet" {
  provider                  = azurerm.prodcution
  name                      = "intertel-prod-scus-vnet_TO_intertel-staging-scus-vnet"
  resource_group_name       = data.azurerm_virtual_network.intertel-prod-scus-vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.intertel-prod-scus-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.main_vnet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

# Add peering to intertel-dev-scus-vnet in int-dev-rg
resource "azurerm_virtual_network_peering" "intertel-staging-scus-vnet_TO_intertel-dev-scus-vnet" {
  name                      = "intertel-staging-scus-vnet_TO_intertel-dev-scus-vnet"
  resource_group_name       = azurerm_resource_group.main_rg.name
  virtual_network_name      = azurerm_virtual_network.main_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.intertel-dev-scus-vnet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

resource "azurerm_virtual_network_peering" "intertel-dev-scus-vnet_TO_intertel-staging-scus-vnet" {
  #provider = 
  name                      = "intertel-dev-scus-vnet_TO_intertel-staging-scus-vnet"
  resource_group_name       = data.azurerm_virtual_network.intertel-dev-scus-vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.intertel-dev-scus-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.main_vnet.id
  allow_forwarded_traffic   = true
  timeouts {
    create = "5m"
    update = "5m"
    read   = "5m"
  }
}

# Add peering to social-devstaging-scus-vnet in RecordsX Technologies tenant for ONT-Prod1 IT-vnet
resource "azurerm_virtual_network_peering" "ont_prod1_it_vnet_social_staging_vnet" {
  provider                     = azurerm.OntellusProd1
  name                         = "it-prod-scus-vnet-TO-social-staging-scus-vnet"
  resource_group_name          = data.azurerm_virtual_network.IT-Prod-SCUS-VNet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.IT-Prod-SCUS-VNet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.social-staging-scus-vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "vnet_social_staging_vnet_ont_prod1_it" {
  provider                     = azurerm.RecordsXTenant
  name                         = "social-staging-scus-vnet-TO-it-prod-scus-vnet"
  resource_group_name          = data.azurerm_virtual_network.social-staging-scus-vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.social-staging-scus-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.IT-Prod-SCUS-VNet.id
  allow_virtual_network_access = true
  depends_on                   = [azurerm_virtual_network_peering.ont_prod1_it_vnet_social_staging_vnet]
}
# end peering to social-staging-scus-vnet

# Add peering to social-staging-scus-vnet in RecordsX Technologies tenant for 
resource "azurerm_virtual_network_peering" "main_vnet-social_social_vnet" {
  provider                     = azurerm.OntellusTenant
  name                         = "intertel-staging-scus-vnet-TO-social-staging-scus-vnet"
  resource_group_name          = azurerm_resource_group.main_rg.name
  virtual_network_name         = azurerm_virtual_network.main_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.social-staging-scus-vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "social_dev_vnet-main_vnet" {
  provider                     = azurerm.RecordsXTenant
  name                         = "social-staging-scus-vnet-TO-intertel-staging-scus-vnet"
  resource_group_name          = data.azurerm_virtual_network.social-staging-scus-vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.social-staging-scus-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.main_vnet.id
  allow_virtual_network_access = true
  depends_on                   = [azurerm_virtual_network_peering.main_vnet-social_social_vnet]
}
# end peering to social-dev-scus-vnet

# Public IP addresses

resource "azurerm_public_ip" "int-staging-ngw-pip01" {
  name                = "int-staging-ngw-scus-pip01"
  resource_group_name = data.azurerm_virtual_network.network-dev-scus-vnet.resource_group_name
  location            = data.azurerm_virtual_network.network-dev-scus-vnet.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# NAT Gateway using static public IP to allow whitelisting on provider services and attach to AVD/Internal snet

resource "azurerm_nat_gateway" "int-staging-ngw" {
  name                    = "ont-dev1-int-staging-scus-ngw"
  location                = azurerm_resource_group.main_rg.location
  resource_group_name     = azurerm_resource_group.main_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "int-staging-ngw" {
  nat_gateway_id       = azurerm_nat_gateway.int-staging-ngw.id
  public_ip_address_id = azurerm_public_ip.int-staging-ngw-pip01.id
}

resource "azurerm_subnet_nat_gateway_association" "int-staging-mgmt-ngw" {
  subnet_id      = azurerm_subnet.mgmt_snet.id
  nat_gateway_id = azurerm_nat_gateway.int-staging-ngw.id
}

resource "azurerm_subnet_nat_gateway_association" "int-staging-avd-ngw" {
  subnet_id      = azurerm_subnet.avd_snet.id
  nat_gateway_id = azurerm_nat_gateway.int-staging-ngw.id
}

resource "azurerm_subnet_nat_gateway_association" "int-staging-internal-ngw" {
  subnet_id      = azurerm_subnet.internal_snet.id
  nat_gateway_id = azurerm_nat_gateway.int-staging-ngw.id
}

# Azure private DNS Zone

resource "azurerm_private_dns_zone" "privatelink-file-dns" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.main_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "privatelink-file-dns-vnet" {
  name                  = "file"
  resource_group_name   = azurerm_resource_group.main_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink-file-dns.name
  virtual_network_id    = azurerm_virtual_network.main_vnet.id
}


------------------------------------
NETWORKING-NSG-RULES.TF

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = { for rule in local.nsg_rules : "${rule.network_security_group_name}_${rule.name}" => rule }

  name                         = each.value.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = try(each.value.source_port_range, null)
  source_port_ranges           = try(each.value.source_port_ranges, null)
  destination_port_range       = try(each.value.destination_port_range, null)
  destination_port_ranges      = try(each.value.destination_port_ranges, null)
  source_address_prefix        = try(each.value.source_address_prefix, null)
  source_address_prefixes      = try(each.value.source_address_prefixes, null)
  destination_address_prefix   = try(each.value.destination_address_prefix, null)
  destination_address_prefixes = try(each.value.destination_address_prefixes, null)
  resource_group_name          = each.value.resource_group_name
  network_security_group_name  = each.value.network_security_group_name
}

locals {
  # Common ports listed as groups of services. Can be used in SR rules in place of individual ports if desired.
  net_service_groups = {
    active_directory          = concat(var.net_services.dns.port, var.net_services.kerberos.port, var.net_services.ldap.port, var.net_services.ntp.port, var.net_services.rpc.port),
    active_directory_tcp_only = concat(var.net_services.global_catalog.port, var.net_services.samba.port, var.net_services.smb.port)
  }


  nsg_rules = [

    # Begin Mgmt Inbound -----------------------------
    {
      name                        = "${var.mgmt_ips.jeff_michou.name}_to_ALL"
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.jeff_michou.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.mgmt_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.ryan_tognarini.name}_to_ALL"
      priority                    = 120
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.ryan_tognarini.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.mgmt_nsg.name
    },
    {
      name                        = "INBOUND_IMPLICIT_DENY"
      priority                    = 4096
      direction                   = "Inbound"
      access                      = "Deny"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.mgmt_nsg.name
    },

    # Begin Mgmt Outbound -----------------------------
    # TBD

    # Begin DMZ Inbound -----------------------------
    {
      name                        = "MGMT_to_ALL"
      priority                    = 108
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_snet_address_prefix
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.jeff_michou.name}_to_ALL"
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.jeff_michou.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.ryan_tognarini.name}_to_ALL"
      priority                    = 120
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.ryan_tognarini.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.tony_cooper_vm.name}_to_ALL_RDP"
      priority                    = 130
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.rdp.port
      source_address_prefix       = var.mgmt_ips.tony_cooper_vm.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "DCs_to_ALL_DS"
      priority                    = 310
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_ranges     = local.net_service_groups.active_directory
      source_address_prefixes     = var.domain_controller_ips
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "DCs_to_ALL_DS_TCP_ONLY"
      priority                    = 311
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = local.net_service_groups.active_directory_tcp_only
      source_address_prefixes     = var.domain_controller_ips
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                         = "ALL_to_WEB01_HTTP"
      priority                     = 330
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = var.net_services.http.port
      source_address_prefix        = "*"
      destination_address_prefixes = azurerm_network_interface.vm-nics[var.server_names.web].private_ip_addresses
      resource_group_name          = azurerm_resource_group.main_rg.name
      network_security_group_name  = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "INBOUND_IMPLICIT_DENY"
      priority                    = 4096
      direction                   = "Inbound"
      access                      = "Deny"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },

    # Begin DMZ Outbound -----------------------------
    {
      name                         = "DMZ_to_DCs_DS"
      priority                     = 310
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_ranges      = local.net_service_groups.active_directory
      source_address_prefix        = "*"
      destination_address_prefixes = var.domain_controller_ips
      resource_group_name          = azurerm_resource_group.main_rg.name
      network_security_group_name  = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                         = "DMZ_to_DCs_DS_TCP_ONLY"
      priority                     = 311
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = local.net_service_groups.active_directory_tcp_only
      source_address_prefix        = "*"
      destination_address_prefixes = var.domain_controller_ips
      resource_group_name          = azurerm_resource_group.main_rg.name
      network_security_group_name  = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "WEB01_to_SQL_MSSQL_TCP"
      priority                    = 330
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.mssql_tcp.port
      source_address_prefixes     = azurerm_network_interface.vm-nics[var.server_names.web].private_ip_addresses
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.sql].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "DMZ_to_INTERNET_HTTP"
      priority                    = 1200
      direction                   = "Outbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.http.port
      source_address_prefix       = "*"
      destination_address_prefix  = "Internet"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },
    {
      name                        = "OUTBOUND_IMPLICIT_DENY"
      priority                    = 4096
      direction                   = "Outbound"
      access                      = "Deny"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.dmz_nsg.name
    },

    # Begin Internal Inbound -----------------------------
    {
      name                        = "MGMT_to_ALL"
      priority                    = 108
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_snet_address_prefix
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.jeff_michou.name}_to_ALL"
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.jeff_michou.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.ryan_tognarini.name}_to_ALL"
      priority                    = 120
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.ryan_tognarini.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.tony_cooper_vm.name}_to_ALL_RDP"
      priority                    = 130
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.rdp.port
      source_address_prefix       = var.mgmt_ips.tony_cooper_vm.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.tony_cooper_vm.name}_to_SQL_MSSQL"
      priority                    = 131
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.mssql_tcp.port
      source_address_prefix       = var.mgmt_ips.tony_cooper_vm.ip
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.sql].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                         = "${var.mgmt_ips.tony_cooper_vm.name}_to_FS_SMB"
      priority                     = 132
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = concat(var.net_services.http.port, var.net_services.smb.port)
      source_address_prefix        = var.mgmt_ips.tony_cooper_vm.ip
      destination_address_prefixes = [azurerm_private_endpoint.file_endpoint.ip_configuration[0].private_ip_address, azurerm_private_endpoint.profile_endpoint.ip_configuration[0].private_ip_address]
      resource_group_name          = azurerm_resource_group.main_rg.name
      network_security_group_name  = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "INTERNAL_to_INTERNAL"
      priority                    = 200
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.internal_snet_address_prefix
      destination_address_prefix  = var.internal_snet_address_prefix
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "WEB01_to_SQL_MSSQL"
      priority                    = 250
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.mssql_tcp.port
      source_address_prefixes     = azurerm_network_interface.vm-nics[var.server_names.web].private_ip_addresses
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.sql].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                         = "AVD_to_FS_SMB"
      priority                     = 310
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = concat(var.net_services.http.port, var.net_services.smb.port)
      source_address_prefix        = var.avd_snet_address_prefix
      destination_address_prefixes = [azurerm_private_endpoint.file_endpoint.ip_configuration[0].private_ip_address, azurerm_private_endpoint.profile_endpoint.ip_configuration[0].private_ip_address]
      resource_group_name          = azurerm_resource_group.main_rg.name
      network_security_group_name  = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "AVD_to_SQL_MSSQL"
      priority                    = 350
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.mssql_tcp.port
      source_address_prefix       = var.avd_snet_address_prefix
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.sql].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "AVD_to_TFS_CUSTOM"
      priority                    = 360
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.tfsserver_custom.port
      source_address_prefix       = var.avd_snet_address_prefix
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.tfs].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.michele_mcquietor.name}_to_SQL_ALL"
      priority                    = 300
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.michele_mcquietor.ip
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.sql].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.mohamed_mohsen_avd.name}_to_SQL_MSSQL"
      priority                    = 305
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_ranges     = var.net_services.mssql_tcp.port
      source_address_prefix       = var.mgmt_ips.mohamed_mohsen_avd.ip
      destination_address_prefix  = azurerm_network_interface.vm-nics[var.server_names.sql].private_ip_address
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },
    {
      name                        = "INBOUND_IMPLICIT_DENY"
      priority                    = 4096
      direction                   = "Inbound"
      access                      = "Deny"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.internal_nsg.name
    },

    # Begin Internal Outbound -----------------------------
    # TBD

    # Begin AVD Inbound -----------------------------
    {
      name                        = "MGMT_to_ALL"
      priority                    = 108
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_snet_address_prefix
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.avd_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.jeff_michou.name}_to_ALL"
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.jeff_michou.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.avd_nsg.name
    },
    {
      name                        = "${var.mgmt_ips.ryan_tognarini.name}_to_ALL"
      priority                    = 120
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = var.mgmt_ips.ryan_tognarini.ip
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.avd_nsg.name
    },
    {
      name                        = "INBOUND_IMPLICIT_DENY"
      priority                    = 4096
      direction                   = "Inbound"
      access                      = "Deny"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      resource_group_name         = azurerm_resource_group.main_rg.name
      network_security_group_name = azurerm_network_security_group.avd_nsg.name
    },

    # Begin AVD Outbound -----------------------------
    # TBD

  ]

}



------------------------------------
PROVIDER.TF

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
  }

  backend "azurerm" {}
}

# Ont-dev1 provider block
provider "azurerm" {
  features {}
  subscription_id = "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
}

# Ont-prod1 provider block
provider "azurerm" {
  features {}
  alias           = "prodcution"
  subscription_id = "58e2361d-344c-4e85-b45b-c7435e9e2a42"
}

# Ontellus cross tenant provider block
provider "azurerm" {
  features {}
  alias                = "OntellusTenant"
  subscription_id      = var.ONT-Dev1-SubID
  tenant_id            = var.Ontellus-Tenant
  client_id            = var.SP-Client-ID
  client_secret        = data.azurerm_key_vault_secret.Terraform-SP.value
  auxiliary_tenant_ids = [var.RecordsX-Technologies-Tenant]
}

# Ontellus cross tenant provider block
provider "azurerm" {
  features {}
  alias                = "RecordsXTenant"
  subscription_id      = var.IntSocial-Dev1-SubID
  tenant_id            = var.RecordsX-Technologies-Tenant
  client_id            = var.SP-Client-ID
  client_secret        = data.azurerm_key_vault_secret.Terraform-SP.value
  auxiliary_tenant_ids = [var.Ontellus-Tenant]
}

# Ontellus Ont-Prod1 cross tenant provider block
provider "azurerm" {
  features {}
  alias                = "OntellusProd1"
  subscription_id      = var.Ont-Prod1-SubID
  tenant_id            = var.Ontellus-Tenant
  client_id            = var.SP-Client-ID
  client_secret        = data.azurerm_key_vault_secret.Terraform-SP.value
  auxiliary_tenant_ids = [var.RecordsX-Technologies-Tenant]
}


---------------------------------------------
STORAGE.TF

# Storage account for domain file shares
resource "azurerm_storage_account" "file_storage_acc" {
  name                = "stgintfiles01"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  large_file_share_enabled = "true"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["172.119.179.173", "47.180.141.242", "52.248.96.7", "35.134.145.242", "65.87.34.242"]
    virtual_network_subnet_ids = [azurerm_subnet.avd_snet.id, azurerm_subnet.internal_snet.id, data.azurerm_subnet.subnet-prod-mgmt.id]
  }
  azure_files_authentication {
    directory_type = "AD"
    # After this there is configuration that can be done in terraform but now set using AZ AD join account PS
  }

  lifecycle {
    ignore_changes = [
      network_rules[0].private_link_access
    ]
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "File_SMB_Contributor_file_ra" {
  scope                = azurerm_storage_account.file_storage_acc.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = var.file_shares_contributor_group_id
}

resource "azurerm_storage_share" "file_share" {
  storage_account_name = azurerm_storage_account.file_storage_acc.name
  access_tier          = "TransactionOptimized"
  for_each             = var.file_shares

  name  = each.key
  quota = each.value.quota
}

resource "azurerm_private_endpoint" "file_endpoint" {
  name                          = "stgintfiles01-pep01"
  resource_group_name           = azurerm_resource_group.main_rg.name
  location                      = azurerm_resource_group.main_rg.location
  subnet_id                     = azurerm_subnet.internal_snet.id
  custom_network_interface_name = "stgintfiles01-nic"

  ip_configuration {
    name               = "stgintfiles01-ip-private"
    private_ip_address = cidrhost(var.internal_snet_address_prefix, 20)
    subresource_name   = "file"
  }

  private_service_connection {
    name                           = "stgintfiles01_psc"
    private_connection_resource_id = azurerm_storage_account.file_storage_acc.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
}

resource "azurerm_private_dns_a_record" "dns_file_share" {
  name                = "stgintfiles01"
  zone_name           = azurerm_private_dns_zone.privatelink-file-dns.name
  resource_group_name = azurerm_resource_group.main_rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.file_endpoint.private_service_connection.0.private_ip_address]
}

# Storage account for AVD profiles
resource "azurerm_storage_account" "file_storage_profiles" {
  name                     = "stgintprofiles01"
  resource_group_name      = azurerm_resource_group.main_rg.name
  location                 = azurerm_resource_group.main_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  large_file_share_enabled = "true"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["172.119.179.173", "47.180.141.242", "52.248.96.7", "35.134.145.242", "65.87.34.242"]
    virtual_network_subnet_ids = [azurerm_subnet.avd_snet.id, azurerm_subnet.internal_snet.id]
  }

  azure_files_authentication {
    directory_type = "AD"
    # After this there is configuration that can be done in terraform but now set using AZ AD join account PS
  }

  lifecycle {
    ignore_changes = [
      network_rules[0].private_link_access
    ]
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "File_SMB_Contributor_Profile_ra" {
  scope                = azurerm_storage_account.file_storage_profiles.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = var.file_profiles_contributor_group_id
}

resource "azurerm_storage_share" "file_storage_profiles" {
  storage_account_name = azurerm_storage_account.file_storage_profiles.name
  access_tier          = "TransactionOptimized"
  for_each             = var.file_profiles

  name  = each.key
  quota = each.value.quota
}

resource "azurerm_private_endpoint" "profile_endpoint" {
  name                          = "stgintprofiles01-pep01"
  resource_group_name           = azurerm_resource_group.main_rg.name
  location                      = azurerm_resource_group.main_rg.location
  subnet_id                     = azurerm_subnet.internal_snet.id
  custom_network_interface_name = "devintprofiles01-nic"

  ip_configuration {
    name               = "stgintprofiles01-ip-private"
    private_ip_address = cidrhost(var.internal_snet_address_prefix, 21)
    subresource_name   = "file"
  }

  private_service_connection {
    name                           = "stgintprofiles01_psc"
    private_connection_resource_id = azurerm_storage_account.file_storage_profiles.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
}

resource "azurerm_private_dns_a_record" "dns_profile_share" {
  name                = "stgintprofiles01"
  zone_name           = azurerm_private_dns_zone.privatelink-file-dns.name
  resource_group_name = azurerm_resource_group.main_rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.profile_endpoint.private_service_connection.0.private_ip_address]
}
#End Storage account for AVD profiles


---------------------------------------
TERRAFORM.TFVARS

# Start groups for access
rg_owner_group_id       = "d4bcbbaa-6acd-4f50-adb2-c5a652760149"
rg_contributor_group_id = "56dc3577-eec9-4016-899a-5b5c1b32eb1d"
rg_reader_group_id      = "e62744b0-8ba9-413c-b26b-89136a7d3fc6"

# Start networking-core.tf vairables
main_vnet_address_space      = ["10.239.88.0/22"]
mgmt_snet_address_prefix     = "10.239.91.0/27"
avd_snet_address_prefix      = "10.239.90.0/24"
dmz_snet_address_prefix      = "10.239.88.0/24"
internal_snet_address_prefix = "10.239.89.0/24"

# Resource Tags
tags = {
  "environment" : "staging"
  "managed by" : "terraform"
  "domain" : "intertel"
  "owner" : "Greg Johnson"
  "Migrate Project" : "INT-MigProject-01"
  #"Business Unit" : "Intertel"
}

AVD_tags = {
  "OffPeakConcurrency" : "0"
  "PeakConcurrency" : "4"
}

AVD_shared_tags = {
  "OffPeakConcurrency" : "1" # number that stay on after hours
  "PeakConcurrency" : "1"    # number that turns on at beginning of day
}

# Start storage.tf vairables
# Start storage private endpoints
# Start containers
file_shares = {
  clientapps : {
    quota = 100
  }
  # codocuments : {
  #   quota = 1
  # }
  # emailattachments : {
  #   quota = 40
  # }
  # humanresources : {
  #   quota = 1
  # }
  # itdept : {
  #   quota = 1
  # }
  # netdata : {
  #   quota = 105
  # }
  # optifiles : {
  #   quota = 1
  # }
  reportgeneration : {
    quota = 290
  }
  # tloxml : {
  #   quota = 5
  # }
}

file_profiles = {
  profiles01 : {
    quota = 100
  }
  mgmt : {
    quota = 5
  }
}
# End Containers
# Start Permissions
file_shares_contributor_group_id   = "6de4764c-52fa-465e-8acd-05111eb87817"
file_profiles_contributor_group_id = "dc7eb76a-c22b-4132-8ab8-57284ca410ed"
# End Permissions
# End storage.tf vairables

# Start virtual-machines.tf variables
virtual_machines = [
  {
    name                  = "STINB2-MGT01"
    size                  = "Standard_B2ms"
    auto_shutdown_enabled = true
    auto_shutdown_time    = 2000
    private_ip_suffix     = 51
    ou_path               = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
  },
  {
    name = "STINB2-SQL01"
    size = "Standard_B8ms"
    source_image = {
      publisher = "microsoftsqlserver",
      offer     = "sql2019-ws2019",
      sku       = "sqldev",
      version   = "latest",
    }
    private_ip_suffix = 52
    ou_path           = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
  },
  {
    name              = "ST-TFSServer"
    size              = "Standard_B2ms"
    private_ip_suffix = 101
    ou_path           = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
    import            = "true"
    import_disk       = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STG-TFSSERVER-OsDisk01"
  },
  {
    name              = "ST-UTILSRV01"
    size              = "Standard_B2ms"
    private_ip_suffix = 102
    ou_path           = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
    import            = "true"
    import_disk       = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STG-UTILSRV01-OSdisk-01"
  },
  {
    name              = "ST-UTILSRV03"
    size              = "Standard_B2ms"
    private_ip_suffix = 103
    ou_path           = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
    import            = "true"
    import_disk       = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STG-UTILSRV03-OSDisk01"
  },
  {
    name                         = "ST-WEB01"
    size                         = "Standard_B2ms"
    private_ip_suffix            = 104
    additional_private_ip_suffix = [161, 162]
    ou_path                      = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
    dmz                          = true
    import                       = "true"
    import_disk                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STG-INB2-WEB01-OSdisk-01"
  },
]

sql_settings = {
  server_name = "STINB2-SQL01",
  data_disks = {
    "data" = {
      name                 = "SQLVMDATA01",
      storage_account_type = "Premium_LRS",
      create_option        = "Empty",
      disk_size_gb         = 1000,
      lun                  = 1,
      default_file_path    = "F:\\SQLDATA",
      caching              = "ReadOnly",
    },
    "logs" = {
      name                 = "SQLVMLOGS",
      storage_account_type = "Standard_LRS",
      create_option        = "Empty",
      disk_size_gb         = 100,
      lun                  = 2,
      default_file_path    = "G:\\SQLLOG",
      caching              = "None",
    },
    "tempdb" = {
      name                 = "SQLVMTEMPDB",
      storage_account_type = "Premium_LRS",
      create_option        = "Empty",
      disk_size_gb         = 100,
      lun                  = 0,
      default_file_path    = "H:\\SQLTEMP",
      caching              = "ReadOnly",
    },
  }
}
# End virtual-machines.tf variables

# AVD and VM Host Join
domain_user_upn = "svc.directoryservice"
domain_name     = "intertel.local"

# AVD Workspace variables
stg_workspace             = "Intertel-Staging"
stg_workspace_friendly    = "Intertel Staging"
stg_workspace_description = "Intertel Staging Workspace"

# Host Pool variables
host_pool = [
  # Mgmt _Personal_ Host Pool
  {
    name                             = "STIN-AVD-MgP"
    display_name                     = "STAGING INTERTEL AVD Mgmt Personal"
    description                      = "AVD personal host pool for Intertel Mgmt"
    source_image                     = "AVD-INT-Mgmt-Win10-img"
    count                            = 2
    size                             = "Standard_B4ms"
    type                             = "Personal"
    load_balancer_type               = "Persistent"
    personal_desktop_assignment_type = "Automatic"
    #maximum_sessions_allowed          = 0
    custom_rdp_properties             = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
    timezone                          = "Central Standard Time"
    subnet                            = "mgmt_snet"
    ou_path                           = "OU=Staging,OU=IN-AVD-MgP,OU=Azure AVD,OU=Azure,DC=intertel,DC=local"
    user_group_desktop_virtualization = "2847240d-38f3-4bed-82de-d821af05904d"
  },

  # Mgmt _Shared_ Host Pool
  {
    name                              = "STIN-AVD-MgS"
    display_name                      = "STAGING INTERTEL AVD Mgmt Shared"
    description                       = "AVD shared host pool for Intertel Mgmt"
    source_image                      = "AVD-INT-Mgmt-Win10-img"
    count                             = 1
    size                              = "Standard_B2ms"
    type                              = "Pooled"
    load_balancer_type                = "BreadthFirst"
    maximum_sessions_allowed          = 12
    custom_rdp_properties             = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
    timezone                          = "Central Standard Time"
    subnet                            = "mgmt_snet"
    ou_path                           = "OU=Staging,OU=IN-AVD-MgS,OU=Azure AVD,OU=Azure,DC=intertel,DC=local"
    user_group_desktop_virtualization = "caf20592-47e9-4528-9e29-e2b39502657b"
  },

  # User Standard Shared Host Pool
  {
    name                              = "STIN-AVD-Std"
    display_name                      = "STAGING INTERTEL AVD Standard"
    description                       = "AVD pooled host pool for Intertel"
    source_image                      = "AVD-INT-Win10-img"
    count                             = 2
    size                              = "Standard_E8s_v5"
    type                              = "Pooled"
    load_balancer_type                = "BreadthFirst"
    maximum_sessions_allowed          = 12
    custom_rdp_properties             = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
    timezone                          = "Central Standard Time"
    subnet                            = "avd_snet"
    ou_path                           = "OU=Staging,OU=IN-AVD-STD01,OU=Azure AVD,OU=Azure,DC=intertel,DC=local"
    user_group_desktop_virtualization = "5d9b8f03-c823-4be9-8c6b-548547bf4c55"
  },

  # User Standard Personal Host Pool
  {
    name                             = "STIN-AVD-PER"
    display_name                     = "STAGING INTERTEL AVD Personal"
    description                      = "AVD personal host pool for Intertel"
    source_image                     = "AVD-INT-Win10-img"
    count                            = 1
    size                             = "Standard_B2ms"
    type                             = "Personal"
    load_balancer_type               = "Persistent"
    personal_desktop_assignment_type = "Automatic"
    #maximum_sessions_allowed          = 0
    custom_rdp_properties             = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
    timezone                          = "Central Standard Time"
    subnet                            = "avd_snet"
    ou_path                           = "OU=Staging,OU=IN-AVD-PER01,OU=Azure AVD,OU=Azure,DC=intertel,DC=local"
    user_group_desktop_virtualization = "956d17cb-382b-4a26-ad94-3f30c35b7383"
  }
]

# Start networking-nsg-rules.tf variables
domain_controller_ips = ["10.249.12.11", "10.249.12.12"]
mgmt_ips = {
  jeff_michou = {
    name = "CCA1-IT-001"
    ip   = "192.168.3.51"
  },
  ryan_tognarini = {
    name = "STL-RT01"
    ip   = "10.1.97.200"
  },
  tony_cooper = {
    name = "TCOOPER01"
    ip   = "10.1.97.10"
  },
  tony_cooper_vm = {
    name = "TCOOPER01-avd"
    ip   = "10.239.94.4/32"
  },
  mohamed_mohsen_avd = {
    name = "DVIN-AVD-DEV-2"
    ip   = "10.239.94.40/32"
  },
  michele_mcquietor = {
    name = "KIO1-RDM01"
    ip   = "10.249.64.55/32"
  }
}
server_names = {
  tfs = "ST-TFSServer",
  web = "ST-WEB01",
  sql = "STINB2-SQL01"
}
net_services = {
  dns = {
    protocol = "*"
    port     = ["53"]
  }
  global_catalog = {
    protocol = "Tcp"
    port     = ["3268", "3269"]
  }
  http = {
    protocol = "Tcp"
    port     = ["80", "443"]
  }
  kerberos = {
    protocol = "*"
    port     = ["88", "464"]
  }
  ldap = {
    protocol = "*"
    port     = ["389", "636"]
  }
  mssql_tcp = {
    protocol = "Tcp"
    port     = ["1433", "1434"]
  }
  mssql_udp = {
    protocol = "Udp"
    port     = ["1434"]
  }
  ntp = {
    protocol = "*"
    port     = ["123"]
  }
  rdp = {
    protocol = "*"
    port     = ["3389"]
  }
  rpc = {
    protocol = "*"
    port     = ["135", "49152-65535"]
  }
  samba = {
    protocol = "Tcp"
    port     = ["139"]
  }
  smb = {
    protocol = "Tcp"
    port     = ["445"]
  }
  tfsserver_custom = {
    protocol = "Tcp"
    port     = ["8080-8099"]
  }
}
# End networking-nsg-rules.tf variables

# Start Cross Tenant Variables
Ontellus-Tenant              = "e69ffd5c-8131-4a50-ac19-b4123a1e5502"
ONT-Dev1-SubID               = "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
RecordsX-Technologies-Tenant = "ea57dc1e-6e92-4b1b-8dcc-adbf3f40ef67"
IntSocial-Dev1-SubID         = "b4ac37ba-5332-4222-aa2c-98cee3fe80ae"
SP-Client-ID                 = "3f31972c-b59f-480d-b4f3-71d39043b74e" ####
Ont-Prod1-SubID              = "58e2361d-344c-4e85-b45b-c7435e9e2a42"
# End Cross Tenant Variables



------------------------------------
VARIABLES.TF

# Permissions Groups
variable "rg_owner_group_id" {}
variable "rg_contributor_group_id" {}
variable "rg_reader_group_id" {}

# Networking VNET & SNET
variable "main_vnet_address_space" {}
variable "mgmt_snet_address_prefix" {}
variable "avd_snet_address_prefix" {}
variable "dmz_snet_address_prefix" {}
variable "internal_snet_address_prefix" {}

# Resource Tags
variable "tags" {}
variable "AVD_tags" {}
variable "AVD_shared_tags" {}

# Start storage.tf variables
variable "file_shares" {}
variable "file_profiles" {}
variable "file_shares_contributor_group_id" {}
variable "file_profiles_contributor_group_id" {}
# End storage.tf variables

# Start virtual-machines.tf variables
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
      sku       = "2019-Datacenter",
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
    ou_path                      = string,
    import                       = optional(bool, false),
    import_disk                  = optional(string)
  }))
}
variable "sql_settings" {
  type = object({
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
  })
}
# End virtual-machines.tf variables

# Start AVD variables
# Pool variables
variable "stg_workspace" {
  type        = string
  description = "Create Workspace for AVD pools"
  #default     = "Intertel-Staging"
}

variable "stg_workspace_friendly" {
  type        = string
  description = "The name seein in the client"
  #default     = "Intertel Staging"
}

variable "stg_workspace_description" {
  type        = string
  description = "Portal workspace discription"
  #default     = "Intertel Staging Workspace"
}

# Computer join account
variable "domain_name" {
  type        = string
  default     = "intertel.local"
  description = "Name of the domain to join"
}

variable "domain_user_upn" {
  type        = string
  default     = "svc.directoryservice" # do not include domain name as this is appended
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "host_pool" {}

# End AVD variables

# Start networking-nsg-rules.tf variables
variable "domain_controller_ips" {
  description = "list of IP addresses to domain controllers"
  type        = list(string)
}
variable "mgmt_ips" {
  description = "Map of management PC names and IP addresses"
  type = map(object({
    name = string
    ip   = string
  }))
}
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
# End networking-nsg-rules.tf variables

# Start Cross Tenant Variables
variable "Ontellus-Tenant" {
  description = "Ontellus tenant ID"
  default     = "e69ffd5c-8131-4a50-ac19-b4123a1e5502"
}

variable "ONT-Dev1-SubID" {
  description = "Ontellus ONT-Dev1 subscription ID"
  default     = "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
}

variable "IntSocial-Dev1-SubID" {
  description = "RecordsX Technologies IntSocial-Dev1 Subscription ID"
  default     = "b4ac37ba-5332-4222-aa2c-98cee3fe80ae"
}

variable "RecordsX-Technologies-Tenant" {
  description = "RecordsX Technologies tenant ID"
  default     = "ea57dc1e-6e92-4b1b-8dcc-adbf3f40ef67"
}

variable "SP-Client-ID" {
  description = "Client ID for the Enterpries App"
  default     = "3f31972c-b59f-480d-b4f3-71d39043b74e"
}
variable "Ont-Prod1-SubID" {
  description = "Ontellus Ont-Prod1 subscription ID"
  default     = "58e2361d-344c-4e85-b45b-c7435e9e2a42"
}

# End Cross Tenant Variables


-----------------------------------------
VIRTUAL-MACHINES.TF

# This is where Intertel servers are created.  There is additional VMs for AVD pools in the avd.tf

# Proximity Placement Grorp
resource "azurerm_proximity_placement_group" "int-stg-ppg" {
  name                = "int-stg-ppg"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  allowed_vm_sizes    = ["Standard_B2ms", "Standard_B8ms", "Standard_E8s_v5"]

  tags = var.tags
}
# Network interfaces
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

# Virtual machines imported into Terraform
resource "azurerm_virtual_machine" "imported-vms" {

  for_each = {
    for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
    if virtual_machine.import == true
  }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  vm_size             = each.value.size

  os_profile {
    computer_name  = each.value.name
    admin_username = "ONTAdmin"
    admin_password = data.azurerm_key_vault_secret.ontadmin.value
  }

  proximity_placement_group_id = azurerm_proximity_placement_group.int-stg-ppg.id

  network_interface_ids = [
    azurerm_network_interface.vm-nics[each.value.name].id
  ]

  storage_os_disk {
    name            = azurerm_managed_disk.imported-disks[each.value.name].name
    caching         = "ReadWrite"
    create_option   = "Attach"
    managed_disk_id = azurerm_managed_disk.imported-disks[each.value.name].id
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      os_profile,
      boot_diagnostics
    ]
  }
  depends_on = [
    azurerm_managed_disk.imported-disks,
    azurerm_network_interface.vm-nics
  ]
}

# Virtual machines provisioned by Terraform
resource "azurerm_windows_virtual_machine" "vms" {
  for_each = {
    for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
    if virtual_machine.import == false
  }

  name                         = each.value.name
  resource_group_name          = azurerm_resource_group.main_rg.name
  location                     = azurerm_resource_group.main_rg.location
  size                         = each.value.size
  admin_username               = "ONTAdmin"
  admin_password               = data.azurerm_key_vault_secret.ontadmin.value
  patch_mode                   = each.value.patch_mode
  enable_automatic_updates     = each.value.enable_automatic_updates
  timezone                     = each.value.timezone
  proximity_placement_group_id = azurerm_proximity_placement_group.int-stg-ppg.id

  network_interface_ids = [
    azurerm_network_interface.vm-nics[each.value.name].id
  ]

  os_disk {
    name                 = "${each.value.name}-disk-os"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image.publisher
    offer     = each.value.source_image.offer
    sku       = each.value.source_image.sku
    version   = each.value.source_image.version
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      admin_password,
      identity
    ]
  }
}

resource "azurerm_virtual_machine_extension" "vms-domain-join" {
  for_each = {
    for virtual_machine in var.virtual_machines : virtual_machine.name => virtual_machine
    #if virtual_machine.import == false # uncomment to prevent imported machines from automatically joining the domain
  }

  name                       = "${each.value.name}-domain-join"
  virtual_machine_id         = try(azurerm_windows_virtual_machine.vms[each.value.name].id, azurerm_virtual_machine.imported-vms[each.value.name].id)
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
      "Password": "${data.azurerm_key_vault_secret.intertel-svc-directoryservice.value}"
    }
  PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [
    azurerm_windows_virtual_machine.vms,
    azurerm_virtual_machine.imported-vms
  ]
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

  tags = var.tags
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
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach,
    azurerm_windows_virtual_machine.vms,
    azurerm_virtual_machine.imported-vms
  ]

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

  virtual_machine_id    = azurerm_windows_virtual_machine.vms[each.value.name].id
  location              = azurerm_resource_group.main_rg.location
  enabled               = each.value.auto_shutdown_enabled
  daily_recurrence_time = each.value.auto_shutdown_time
  timezone              = each.value.timezone

  notification_settings {
    enabled = false
  }

  tags = var.tags
}




===============================================================================================================


az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/int-staging-rg$ terraform plan
data.azurerm_virtual_network.IT-Prod-SCUS-VNet: Reading...
data.azurerm_virtual_network.intertel-prod-scus-vnet: Reading...
data.azurerm_subnet.subnet-prod-mgmt: Reading...
data.azurerm_shared_image.AVD-INT-Win10-img: Reading...
data.azurerm_virtual_network.MR8-Prod-SCUS-VNet: Reading...
data.azurerm_shared_image.AVD-INT-Mgmt-Win10-img: Reading...
data.azurerm_key_vault.ONT-IT-KeyVault: Reading...
data.azurerm_subnet.subnet-prod-mgmt: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/int-prod-rg/providers/Microsoft.Network/virtualNetworks/intertel-prod-scus-vnet/subnets/intertel-prod-mgmt-scus-snet]
data.azurerm_virtual_network.IT-Prod-SCUS-VNet: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Network/virtualNetworks/IT-Prod-SCUS-VNet]
data.azurerm_virtual_network.intertel-prod-scus-vnet: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/int-prod-rg/providers/Microsoft.Network/virtualNetworks/intertel-prod-scus-vnet]
data.azurerm_shared_image.AVD-INT-Win10-img: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-INT-Win10-img]
data.azurerm_shared_image.AVD-INT-Mgmt-Win10-img: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-INT-Mgmt-Win10-img]
data.azurerm_key_vault.ONT-IT-KeyVault: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.KeyVault/vaults/ONT-IT-KeyVault]
data.azurerm_key_vault_secret.ontadmin: Reading...
data.azurerm_key_vault_secret.Terraform-SP: Reading...
data.azurerm_key_vault_secret.intertel-svc-directoryservice: Reading...
data.azurerm_virtual_network.MR8-Prod-SCUS-VNet: Read complete after 0s [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/MR8-PROD-rg/providers/Microsoft.Network/virtualNetworks/MR8-Prod-SCUS-VNet]
data.azurerm_route_table.dev-scus-rt: Reading...
data.azurerm_virtual_network.intertel-dev-scus-vnet: Reading...
data.azurerm_virtual_network.network-dev-scus-vnet: Reading...
azurerm_resource_group.main_rg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg]
data.azurerm_route_table.dev-scus-rt: Read complete after 0s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt]
data.azurerm_virtual_network.intertel-dev-scus-vnet: Read complete after 0s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-dev-rg/providers/Microsoft.Network/virtualNetworks/intertel-dev-scus-vnet]
data.azurerm_virtual_network.network-dev-scus-vnet: Read complete after 0s [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/virtualNetworks/network-dev-scus-vnet]
azurerm_public_ip.int-staging-ngw-pip01: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/publicIPAddresses/int-staging-ngw-scus-pip01]
azurerm_nat_gateway.int-staging-ngw: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/natGateways/ont-dev1-int-staging-scus-ngw]
azurerm_virtual_network.main_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet]
azurerm_role_assignment.reader_ra: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Authorization/roleAssignments/638ffbe4-6d6b-c91a-040b-d0d1010644f3]
azurerm_role_assignment.contributor_ra: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Authorization/roleAssignments/fad004b0-e10c-86f6-1f18-fbde1602184c]
azurerm_private_dns_zone.privatelink-file-dns: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net]
azurerm_network_security_group.dmz_nsg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg]
azurerm_virtual_desktop_workspace.stg_workspace: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging]
azurerm_role_assignment.owner_ra: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Authorization/roleAssignments/5ea8d9d9-8b60-9993-9399-43350bf225ea]
azurerm_network_security_group.internal_nsg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg]
azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-Std"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-Std]
azurerm_managed_disk.imported-disks["ST-TFSServer"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-TFSServer-OsDisk-01]
azurerm_network_security_group.mgmt_nsg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-mgmt-scus-nsg]
azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-MgP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-MgP]
azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-MgS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-MgS]
azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-PER"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-PER]
azurerm_network_security_group.avd_nsg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-avd-scus-nsg]
azurerm_proximity_placement_group.int-stg-ppg: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg]
azurerm_managed_disk.imported-disks["ST-WEB01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-WEB01-OSdisk-01]
azurerm_managed_disk.imported-disks["ST-UTILSRV01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-UTILSRV01-OsDisk-01]
azurerm_managed_disk.imported-disks["ST-UTILSRV03"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/ST-UTILSRV03-OsDisk-01]
azurerm_managed_disk.vm-sql-disks["logs"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STINB2-SQL01-disk-SQLVMLOGS]
azurerm_managed_disk.vm-sql-disks["tempdb"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STINB2-SQL01-disk-SQLVMTEMPDB]
azurerm_managed_disk.vm-sql-disks["data"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STINB2-SQL01-disk-SQLVMDATA01]
azurerm_virtual_network_peering.intertel-staging-scus-vnet_TO_intertel-prod-scus-vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/virtualNetworkPeerings/intertel-staging-scus-vnet_TO_intertel-prod-scus-vnet]
azurerm_subnet.internal_snet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet]
azurerm_virtual_network_peering.intertel-prod-scus-vnet_TO_intertel-staging-scus-vnet: Refreshing state... [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/int-prod-rg/providers/Microsoft.Network/virtualNetworks/intertel-prod-scus-vnet/virtualNetworkPeerings/intertel-prod-scus-vnet_TO_intertel-staging-scus-vnet]
azurerm_virtual_network_peering.MR8-Prod-SCUS-VNet_main_vnet: Refreshing state... [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/MR8-PROD-rg/providers/Microsoft.Network/virtualNetworks/MR8-Prod-SCUS-VNet/virtualNetworkPeerings/MR8-Prod-SCUS-VNet-TO-intertel-staging-scus-vnet]
azurerm_subnet.avd_snet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-avd-scus-snet]
azurerm_virtual_network_peering.network-dev-scus-vnet_main_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/virtualNetworks/network-dev-scus-vnet/virtualNetworkPeerings/network-dev-scus-vnet-TO-intertel-staging-scus-vnet]
azurerm_virtual_network_peering.main_vnet_MR8-Prod-SCUS-VNet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/virtualNetworkPeerings/intertel-staging-scus-vnet-TO-MR8-Prod-SCUS-VNet]
azurerm_virtual_network_peering.main_vnet_it_vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/virtualNetworkPeerings/intertel-staging-scus-vnet-TO-it-prod-scus-vnet]
azurerm_virtual_network_peering.prod_it_vnet_main_vnet: Refreshing state... [id=/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Network/virtualNetworks/IT-Prod-SCUS-VNet/virtualNetworkPeerings/it-prod-scus-vnet-TO-intertel-staging-scus-vnet]
azurerm_virtual_network_peering.main_vnet_network-dev-scus-vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/virtualNetworkPeerings/intertel-staging-scus-vnet-TO-network-dev-scus-vnet]
azurerm_subnet.dmz_snet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-dmz-scus-snet]
azurerm_virtual_network_peering.intertel-dev-scus-vnet_TO_intertel-staging-scus-vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-dev-rg/providers/Microsoft.Network/virtualNetworks/intertel-dev-scus-vnet/virtualNetworkPeerings/intertel-dev-scus-vnet_TO_intertel-staging-scus-vnet]
azurerm_subnet.mgmt_snet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet]
azurerm_virtual_network_peering.intertel-staging-scus-vnet_TO_intertel-dev-scus-vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/virtualNetworkPeerings/intertel-staging-scus-vnet_TO_intertel-dev-scus-vnet]
azurerm_nat_gateway_public_ip_association.int-staging-ngw: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/natGateways/ont-dev1-int-staging-scus-ngw|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/publicIPAddresses/int-staging-ngw-scus-pip01]
azurerm_private_dns_zone_virtual_network_link.privatelink-file-dns-vnet: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net/virtualNetworkLinks/file]
azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-MgS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-MgS-dag]
azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-MgP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-MgP-dag]
azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-PER"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-PER-dag]
azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-Std"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag]
azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-PER"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-PER/registrationInfo/default]
azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-Std"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-Std/registrationInfo/default]
azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-MgP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-MgP/registrationInfo/default]
azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-MgS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-MgS/registrationInfo/default]
azurerm_subnet_nat_gateway_association.int-staging-avd-ngw: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-avd-scus-snet]
azurerm_storage_account.file_storage_profiles: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Storage/storageAccounts/stgintprofiles01]
azurerm_subnet_route_table_association.internal_snet_rt_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet]
azurerm_storage_account.file_storage_acc: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Storage/storageAccounts/stgintfiles01]
azurerm_subnet_nat_gateway_association.int-staging-internal-ngw: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet]
azurerm_subnet_network_security_group_association.internal_nsg_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet]
azurerm_subnet_network_security_group_association.avd_nsg_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-avd-scus-snet]
azurerm_subnet_route_table_association.avd_snet_rt_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-avd-scus-snet]
azurerm_subnet_route_table_association.dmz_snet_rt_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-dmz-scus-snet]
azurerm_subnet_network_security_group_association.dmz_nsg_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-dmz-scus-snet]
azurerm_network_interface.vm-nics["ST-UTILSRV03"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/ST-UTILSRV03-nic]
azurerm_network_interface.vm-nics["ST-WEB01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/ST-WEB01-nic]
azurerm_network_interface.vm-nics["STINB2-MGT01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STINB2-MGT01-nic]
azurerm_network_interface.vm-nics["STINB2-SQL01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STINB2-SQL01-nic]
azurerm_network_interface.vm-nics["ST-TFSServer"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/ST-TFSServer-nic]
azurerm_network_interface.vm-nics["ST-UTILSRV01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/ST-UTILSRV01-nic]
azurerm_subnet_network_security_group_association.mgmt_nsg_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet]
azurerm_subnet_route_table_association.mgmt_snet_rt_association: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet]
azurerm_subnet_nat_gateway_association.int-staging-mgmt-ngw: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet]
azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-MgS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-MgS-dag]
azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-PER"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-PER-dag]
azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-MgP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-MgP-dag]
azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-Std"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag]
azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-PER"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-PER-dag/providers/Microsoft.Authorization/roleAssignments/0eaf65b7-1fe6-0f06-cdac-441ede33e5fe]
azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-Std"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag/providers/Microsoft.Authorization/roleAssignments/bae99884-1ae1-3c44-0210-c635e37ed6bf]
azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-MgP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-MgP-dag/providers/Microsoft.Authorization/roleAssignments/6601356e-2d75-224c-0fc7-764b0f156fa1]
azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-MgS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-MgS-dag/providers/Microsoft.Authorization/roleAssignments/029effa8-a033-1605-d93c-b0d348ea2146]
azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-MgP-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STIN-AVD-MgP-2-nic]
azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-MgS-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STIN-AVD-MgS-1-nic]
azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-PER-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STIN-AVD-PER-1-nic]
azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-Std-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STIN-AVD-Std-1-nic]
azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-Std-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STIN-AVD-Std-2-nic]
azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-MgP-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/STIN-AVD-MgP-1-nic]
azurerm_storage_share.file_share["optifiles"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/optifiles]
azurerm_storage_share.file_share["tloxml"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/tloxml]
azurerm_storage_share.file_share["reportgeneration"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/reportgeneration]
azurerm_storage_share.file_share["codocuments"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/codocuments]
azurerm_role_assignment.File_SMB_Contributor_file_ra: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Storage/storageAccounts/stgintfiles01/providers/Microsoft.Authorization/roleAssignments/a0b242bf-b606-7908-5bd1-a321a2aea00d]
azurerm_storage_share.file_share["emailattachments"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/emailattachments]
azurerm_storage_share.file_share["humanresources"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/humanresources]
azurerm_storage_share.file_share["itdept"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/itdept]
azurerm_storage_share.file_share["netdata"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/netdata]
azurerm_storage_share.file_share["clientapps"]: Refreshing state... [id=https://stgintfiles01.file.core.windows.net/clientapps]
azurerm_private_endpoint.file_endpoint: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/privateEndpoints/stgintfiles01-pep01]
azurerm_private_dns_a_record.dns_file_share: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net/A/stgintfiles01]
data.azurerm_key_vault_secret.intertel-svc-directoryservice: Read complete after 6s [id=https://ont-it-keyvault.vault.azure.net/secrets/intertel-svc-directoryservice/bbfa0b5bf0014d4e912282e030dfd283]
data.azurerm_key_vault_secret.Terraform-SP: Read complete after 6s [id=https://ont-it-keyvault.vault.azure.net/secrets/3f31972c-b59f-480d-b4f3-71d39043b74e/4c1e89f486654625957067ff879990f0]
data.azurerm_key_vault_secret.ontadmin: Read complete after 6s [id=https://ont-it-keyvault.vault.azure.net/secrets/ontadmin/fa0ca39a91b84c629431428f4d20f079]
azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-2]
azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-PER-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-PER-1]
azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-MgS-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgS-1]
azurerm_windows_virtual_machine.vms["STINB2-MGT01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-MGT01]
azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-1]
azurerm_windows_virtual_machine.vms["STINB2-SQL01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01]
azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-MgP-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgP-2]
azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-MgP-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgP-1]
azurerm_virtual_machine.imported-vms["ST-TFSServer"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-TFSServer]
azurerm_virtual_machine.imported-vms["ST-UTILSRV01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV01]
azurerm_virtual_machine.imported-vms["ST-UTILSRV03"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV03]
azurerm_dev_test_global_vm_shutdown_schedule.vm-autoshutdown["STINB2-MGT01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DevTestLab/schedules/shutdown-computevm-STINB2-MGT01]
azurerm_virtual_machine.imported-vms["ST-WEB01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-WEB01]
azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["data"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01/dataDisks/STINB2-SQL01-disk-SQLVMDATA01]
azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["logs"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01/dataDisks/STINB2-SQL01-disk-SQLVMLOGS]
azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["tempdb"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01/dataDisks/STINB2-SQL01-disk-SQLVMTEMPDB]
azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-Std-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-1/extensions/STIN-AVD-Std-1-domain-join]
azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-Std-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-2/extensions/STIN-AVD-Std-2-domain-join]
azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-MgP-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgP-1/extensions/STIN-AVD-MgP-1-domain-join]
azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-MgP-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgP-2/extensions/STIN-AVD-MgP-2-domain-join]
azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-MgS-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgS-1/extensions/STIN-AVD-MgS-1-domain-join]
azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-PER-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-PER-1/extensions/STIN-AVD-PER-1-domain-join]
azurerm_virtual_machine_extension.vms-domain-join["STINB2-MGT01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-MGT01/extensions/STINB2-MGT01-domain-join]
azurerm_virtual_machine_extension.vms-domain-join["STINB2-SQL01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01/extensions/STINB2-SQL01-domain-join]
azurerm_virtual_machine_extension.vms-domain-join["ST-TFSServer"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-TFSServer/extensions/ST-TFSServer-domain-join]
azurerm_virtual_machine_extension.vms-domain-join["ST-UTILSRV03"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV03/extensions/ST-UTILSRV03-domain-join]
azurerm_virtual_machine_extension.vms-domain-join["ST-WEB01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-WEB01/extensions/ST-WEB01-domain-join]
azurerm_mssql_virtual_machine.vm-sql: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.SqlVirtualMachine/sqlVirtualMachines/STINB2-SQL01]
azurerm_virtual_machine_extension.vms-domain-join["ST-UTILSRV01"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV01/extensions/ST-UTILSRV01-domain-join]
azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-2/extensions/STIN-AVD-Std-2-dsc]
azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-1/extensions/STIN-AVD-Std-1-dsc]
azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-MgP-2"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgP-2/extensions/STIN-AVD-MgP-2-dsc]
azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-MgS-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgS-1/extensions/STIN-AVD-MgS-1-dsc]
azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-MgP-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-MgP-1/extensions/STIN-AVD-MgP-1-dsc]
azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-PER-1"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-PER-1/extensions/STIN-AVD-PER-1-dsc]
azurerm_private_endpoint.profile_endpoint: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/privateEndpoints/stgintprofiles01-pep01]
azurerm_role_assignment.File_SMB_Contributor_Profile_ra: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Storage/storageAccounts/stgintprofiles01/providers/Microsoft.Authorization/roleAssignments/795c61ef-6b16-e655-9ac3-367810a584e7]
azurerm_storage_share.file_storage_profiles["mgmt"]: Refreshing state... [id=https://stgintprofiles01.file.core.windows.net/mgmt]
azurerm_storage_share.file_storage_profiles["profiles01"]: Refreshing state... [id=https://stgintprofiles01.file.core.windows.net/profiles01]
azurerm_private_dns_a_record.dns_profile_share: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net/A/stgintprofiles01]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_INBOUND_IMPLICIT_DENY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/INBOUND_IMPLICIT_DENY]
azurerm_network_security_rule.nsg_rules["intertel-staging-mgmt-scus-nsg_CCA1-IT-001_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-mgmt-scus-nsg/securityRules/CCA1-IT-001_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_INTERNAL_to_INTERNAL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/INTERNAL_to_INTERNAL]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_WEB01_to_SQL_MSSQL_TCP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/WEB01_to_SQL_MSSQL_TCP]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_AVD_to_FS_SMB"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/AVD_to_FS_SMB]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_MGMT_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/MGMT_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_DCs_to_ALL_DS_TCP_ONLY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/DCs_to_ALL_DS_TCP_ONLY]
azurerm_network_security_rule.nsg_rules["intertel-staging-avd-scus-nsg_MGMT_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-avd-scus-nsg/securityRules/MGMT_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_DMZ_to_DCs_DS_TCP_ONLY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/DMZ_to_DCs_DS_TCP_ONLY]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_AVD_to_SQL_MSSQL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/AVD_to_SQL_MSSQL]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_CCA1-IT-001_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/CCA1-IT-001_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_KIO1-RDM01_to_SQL_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/KIO1-RDM01_to_SQL_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-mgmt-scus-nsg_STL-RT01_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-mgmt-scus-nsg/securityRules/STL-RT01_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_TCOOPER01-avd_to_ALL_RDP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/TCOOPER01-avd_to_ALL_RDP]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_AVD_to_TFS_CUSTOM"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/AVD_to_TFS_CUSTOM]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_INBOUND_IMPLICIT_DENY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/INBOUND_IMPLICIT_DENY]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_STL-RT01_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/STL-RT01_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_TCOOPER01-avd_to_FS_SMB"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/TCOOPER01-avd_to_FS_SMB]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_DVIN-AVD-DEV-2_to_SQL_MSSQL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/DVIN-AVD-DEV-2_to_SQL_MSSQL]
azurerm_network_security_rule.nsg_rules["intertel-staging-avd-scus-nsg_CCA1-IT-001_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-avd-scus-nsg/securityRules/CCA1-IT-001_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_WEB01_to_SQL_MSSQL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/WEB01_to_SQL_MSSQL]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_ALL_to_WEB01_HTTP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/ALL_to_WEB01_HTTP]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_MGMT_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/MGMT_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_DCs_to_ALL_DS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/DCs_to_ALL_DS]
azurerm_network_security_rule.nsg_rules["intertel-staging-avd-scus-nsg_STL-RT01_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-avd-scus-nsg/securityRules/STL-RT01_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-avd-scus-nsg_INBOUND_IMPLICIT_DENY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-avd-scus-nsg/securityRules/INBOUND_IMPLICIT_DENY]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_TCOOPER01-avd_to_SQL_MSSQL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/TCOOPER01-avd_to_SQL_MSSQL]
azurerm_network_security_rule.nsg_rules["intertel-staging-mgmt-scus-nsg_INBOUND_IMPLICIT_DENY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-mgmt-scus-nsg/securityRules/INBOUND_IMPLICIT_DENY]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_DMZ_to_DCs_DS"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/DMZ_to_DCs_DS]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_TCOOPER01-avd_to_ALL_RDP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/TCOOPER01-avd_to_ALL_RDP]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_OUTBOUND_IMPLICIT_DENY"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/OUTBOUND_IMPLICIT_DENY]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_DMZ_to_INTERNET_HTTP"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/DMZ_to_INTERNET_HTTP]
azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_STL-RT01_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/STL-RT01_to_ALL]
azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_CCA1-IT-001_to_ALL"]: Refreshing state... [id=/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/CCA1-IT-001_to_ALL]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create
  ~ update in-place
-/+ destroy and then create replacement

Terraform planned the following actions, but then encountered a problem:

  # azurerm_dev_test_global_vm_shutdown_schedule.vm-autoshutdown["STINB2-MGT01"] will be created
  + resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm-autoshutdown" {
      + daily_recurrence_time = "2000"
      + enabled               = true
      + id                    = (known after apply)
      + location              = "southcentralus"
      + tags                  = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + timezone              = "Central Standard Time"
      + virtual_machine_id    = (known after apply)

      + notification_settings {
          + enabled         = false
          + time_in_minutes = 30
        }
    }

  # azurerm_managed_disk.vm-sql-disks["data"] will be updated in-place
  ~ resource "azurerm_managed_disk" "vm-sql-disks" {
      ~ disk_size_gb                     = 2048 -> 1000
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/disks/STINB2-SQL01-disk-SQLVMDATA01"
        name                             = "STINB2-SQL01-disk-SQLVMDATA01"
        tags                             = {
            "Migrate Project" = "INT-MigProject-01"
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (27 unchanged attributes hidden)
    }

  # azurerm_managed_disk.vm-sql-disks["logs"] will be created
  + resource "azurerm_managed_disk" "vm-sql-disks" {
      + create_option                 = "Empty"
      + disk_iops_read_only           = (known after apply)
      + disk_iops_read_write          = (known after apply)
      + disk_mbps_read_only           = (known after apply)
      + disk_mbps_read_write          = (known after apply)
      + disk_size_gb                  = 100
      + id                            = (known after apply)
      + location                      = "southcentralus"
      + logical_sector_size           = (known after apply)
      + max_shares                    = (known after apply)
      + name                          = "STINB2-SQL01-disk-SQLVMLOGS"
      + public_network_access_enabled = true
      + resource_group_name           = "int-staging-rg"
      + source_uri                    = (known after apply)
      + storage_account_type          = "Standard_LRS"
      + tags                          = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + tier                          = (known after apply)
    }

  # azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-MgP-1"] will be created
  + resource "azurerm_network_interface" "pooled_host_pool_vm_nics" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "southcentralus"
      + mac_address                   = (known after apply)
      + name                          = "STIN-AVD-MgP-1-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "int-staging-rg"
      + tags                          = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "STIN-AVD-MgP-1-nic-ip"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet"
        }
    }

  # azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-MgP-2"] will be created
  + resource "azurerm_network_interface" "pooled_host_pool_vm_nics" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "southcentralus"
      + mac_address                   = (known after apply)
      + name                          = "STIN-AVD-MgP-2-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "int-staging-rg"
      + tags                          = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "STIN-AVD-MgP-2-nic-ip"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet"
        }
    }

  # azurerm_network_interface.pooled_host_pool_vm_nics["STIN-AVD-MgS-1"] will be created
  + resource "azurerm_network_interface" "pooled_host_pool_vm_nics" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "southcentralus"
      + mac_address                   = (known after apply)
      + name                          = "STIN-AVD-MgS-1-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "int-staging-rg"
      + tags                          = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "STIN-AVD-MgS-1-nic-ip"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet"
        }
    }

  # azurerm_network_interface.vm-nics["ST-WEB01"] will be updated in-place
  ~ resource "azurerm_network_interface" "vm-nics" {
        id                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkInterfaces/ST-WEB01-nic"
        name                          = "ST-WEB01-nic"
        tags                          = {
            "Migrate Project" = "INT-MigProject-01"
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (13 unchanged attributes hidden)

      - ip_configuration {
          - name                                               = "ST-WEB01-additional-ip-3" -> null
          - primary                                            = false -> null
          - private_ip_address                                 = "10.239.88.163" -> null
          - private_ip_address_allocation                      = "Static" -> null
          - private_ip_address_version                         = "IPv4" -> null
          - subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-dmz-scus-snet" -> null
            # (2 unchanged attributes hidden)
        }

        # (3 unchanged blocks hidden)
    }

  # azurerm_network_interface.vm-nics["STINB2-MGT01"] will be created
  + resource "azurerm_network_interface" "vm-nics" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "southcentralus"
      + mac_address                   = (known after apply)
      + name                          = "STINB2-MGT01-nic"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "int-staging-rg"
      + tags                          = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "STINB2-MGT01-nic-ip"
          + primary                                            = true
          + private_ip_address                                 = "10.239.89.51"
          + private_ip_address_allocation                      = "Static"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet"
        }
    }

  # azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_ALL_to_WEB01_HTTP"] will be updated in-place
  ~ resource "azurerm_network_security_rule" "nsg_rules" {
      ~ destination_address_prefixes               = [
          + "10.239.88.163",
            # (3 unchanged elements hidden)
        ]
        id                                         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/ALL_to_WEB01_HTTP"
        name                                       = "ALL_to_WEB01_HTTP"
        # (16 unchanged attributes hidden)
    }

  # azurerm_network_security_rule.nsg_rules["intertel-staging-dmz-scus-nsg_WEB01_to_SQL_MSSQL_TCP"] will be updated in-place
  ~ resource "azurerm_network_security_rule" "nsg_rules" {
        id                                         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-dmz-scus-nsg/securityRules/WEB01_to_SQL_MSSQL_TCP"
        name                                       = "WEB01_to_SQL_MSSQL_TCP"
      ~ source_address_prefixes                    = [
          + "10.239.88.163",
            # (3 unchanged elements hidden)
        ]
        # (16 unchanged attributes hidden)
    }

  # azurerm_network_security_rule.nsg_rules["intertel-staging-inernal-scus-nsg_WEB01_to_SQL_MSSQL"] will be updated in-place
  ~ resource "azurerm_network_security_rule" "nsg_rules" {
        id                                         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/networkSecurityGroups/intertel-staging-inernal-scus-nsg/securityRules/WEB01_to_SQL_MSSQL"
        name                                       = "WEB01_to_SQL_MSSQL"
      ~ source_address_prefixes                    = [
          + "10.239.88.163",
            # (3 unchanged elements hidden)
        ]
        # (16 unchanged attributes hidden)
    }

  # azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-MgP"] will be created
  + resource "azurerm_role_assignment" "pooled_host_pool_role_assign" {
      + id                               = (known after apply)
      + name                             = (known after apply)
      + principal_id                     = "2847240d-38f3-4bed-82de-d821af05904d"
      + principal_type                   = (known after apply)
      + role_definition_id               = (known after apply)
      + role_definition_name             = "Desktop Virtualization User"
      + scope                            = (known after apply)
      + skip_service_principal_aad_check = (known after apply)
    }

  # azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-MgS"] will be created
  + resource "azurerm_role_assignment" "pooled_host_pool_role_assign" {
      + id                               = (known after apply)
      + name                             = (known after apply)
      + principal_id                     = "caf20592-47e9-4528-9e29-e2b39502657b"
      + principal_type                   = (known after apply)
      + role_definition_id               = (known after apply)
      + role_definition_name             = "Desktop Virtualization User"
      + scope                            = (known after apply)
      + skip_service_principal_aad_check = (known after apply)
    }

  # azurerm_role_assignment.pooled_host_pool_role_assign["STIN-AVD-Std"] must be replaced
-/+ resource "azurerm_role_assignment" "pooled_host_pool_role_assign" {
      ~ id                                     = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag/providers/Microsoft.Authorization/roleAssignments/bae99884-1ae1-3c44-0210-c635e37ed6bf" -> (known after apply)
      ~ name                                   = "bae99884-1ae1-3c44-0210-c635e37ed6bf" -> (known after apply)
      ~ principal_type                         = "Group" -> (known after apply)
      ~ role_definition_id                     = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/providers/Microsoft.Authorization/roleDefinitions/1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63" -> (known after apply)
      ~ scope                                  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag" -> (known after apply) # forces replacement
      + skip_service_principal_aad_check       = (known after apply)
        # (6 unchanged attributes hidden)
    }

  # azurerm_storage_account.file_storage_profiles will be updated in-place
  ~ resource "azurerm_storage_account" "file_storage_profiles" {
        id                                = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Storage/storageAccounts/stgintprofiles01"
        name                              = "stgintprofiles01"
        tags                              = {
            "Migrate Project" = "INT-MigProject-01"
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (42 unchanged attributes hidden)

      ~ network_rules {
          ~ ip_rules                   = [
              - "23.251.206.250",
                # (5 unchanged elements hidden)
            ]
            # (3 unchanged attributes hidden)

            # (1 unchanged block hidden)
        }

        # (4 unchanged blocks hidden)
    }

  # azurerm_subnet_route_table_association.avd_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "avd_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-avd-scus-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_route_table_association.dmz_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "dmz_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-dmz-scus-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_route_table_association.internal_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "internal_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_subnet_route_table_association.mgmt_snet_rt_association must be replaced
-/+ resource "azurerm_subnet_route_table_association" "mgmt_snet_rt_association" {
      ~ id             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-mgmt-scus-snet" -> (known after apply)
      ~ route_table_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/networkservices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/NetworkServices-dev-scus-rg/providers/Microsoft.Network/routeTables/dev-scus-rt" # forces replacement
        # (1 unchanged attribute hidden)
    }

  # azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-MgP"] will be created
  + resource "azurerm_virtual_desktop_application_group" "pooled_host_pool_dag" {
      + default_desktop_display_name = "STAGING INTERTEL AVD Mgmt Personal"
      + description                  = "Desktop application group for STIN-AVD-MgP"
      + friendly_name                = "STIN-AVD-MgP-dag"
      + host_pool_id                 = (known after apply)
      + id                           = (known after apply)
      + location                     = "southcentralus"
      + name                         = "STIN-AVD-MgP-dag"
      + resource_group_name          = "int-staging-rg"
      + type                         = "Desktop"
    }

  # azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-MgS"] will be created
  + resource "azurerm_virtual_desktop_application_group" "pooled_host_pool_dag" {
      + default_desktop_display_name = "STAGING INTERTEL AVD Mgmt Shared"
      + description                  = "Desktop application group for STIN-AVD-MgS"
      + friendly_name                = "STIN-AVD-MgS-dag"
      + host_pool_id                 = (known after apply)
      + id                           = (known after apply)
      + location                     = "southcentralus"
      + name                         = "STIN-AVD-MgS-dag"
      + resource_group_name          = "int-staging-rg"
      + type                         = "Desktop"
    }

  # azurerm_virtual_desktop_application_group.pooled_host_pool_dag["STIN-AVD-Std"] must be replaced
-/+ resource "azurerm_virtual_desktop_application_group" "pooled_host_pool_dag" {
      ~ host_pool_id                 = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-Std" -> (known after apply) # forces replacement
      ~ id                           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag" -> (known after apply)
        name                         = "STIN-AVD-Std-dag"
      - tags                         = {} -> null
        # (6 unchanged attributes hidden)
    }

  # azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-MgP"] will be created
  + resource "azurerm_virtual_desktop_host_pool" "pooled_host_pool" {
      + custom_rdp_properties            = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
      + description                      = "AVD personal host pool for Intertel Mgmt"
      + friendly_name                    = "STIN-AVD-MgP"
      + id                               = (known after apply)
      + load_balancer_type               = "Persistent"
      + location                         = "southcentralus"
      + maximum_sessions_allowed         = 999999
      + name                             = "STIN-AVD-MgP"
      + personal_desktop_assignment_type = "Automatic"
      + preferred_app_group_type         = "Desktop"
      + resource_group_name              = "int-staging-rg"
      + start_vm_on_connect              = true
      + tags                             = {
          + "Migrate Project"    = "INT-MigProject-01"
          + "OffPeakConcurrency" = "1"
          + "PeakConcurrency"    = "1"
          + "domain"             = "intertel"
          + "environment"        = "staging"
          + "managed by"         = "terraform"
          + "owner"              = "Greg Johnson"
        }
      + type                             = "Personal"
      + validate_environment             = true
    }

  # azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-MgS"] will be created
  + resource "azurerm_virtual_desktop_host_pool" "pooled_host_pool" {
      + custom_rdp_properties    = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
      + description              = "AVD shared host pool for Intertel Mgmt"
      + friendly_name            = "STIN-AVD-MgS"
      + id                       = (known after apply)
      + load_balancer_type       = "BreadthFirst"
      + location                 = "southcentralus"
      + maximum_sessions_allowed = 12
      + name                     = "STIN-AVD-MgS"
      + preferred_app_group_type = "Desktop"
      + resource_group_name      = "int-staging-rg"
      + start_vm_on_connect      = true
      + tags                     = {
          + "Migrate Project"    = "INT-MigProject-01"
          + "OffPeakConcurrency" = "1"
          + "PeakConcurrency"    = "1"
          + "domain"             = "intertel"
          + "environment"        = "staging"
          + "managed by"         = "terraform"
          + "owner"              = "Greg Johnson"
        }
      + type                     = "Pooled"
      + validate_environment     = true
    }

  # azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-PER"] will be updated in-place
  ~ resource "azurerm_virtual_desktop_host_pool" "pooled_host_pool" {
      ~ custom_rdp_properties            = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;redirectwebauthn:i:1;" -> "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:0;redirectsmartcards:i:0;usbdevicestoredirect:s:;enablecredsspsupport:i:1;audiocapturemode:i:1;use multimon:i:1;camerastoredirect:s:;enablerdsaadauth:i:1;"
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-PER"
        name                             = "STIN-AVD-PER"
        tags                             = {
            "Migrate Project"    = "INT-MigProject-01"
            "OffPeakConcurrency" = "1"
            "PeakConcurrency"    = "1"
            "domain"             = "intertel"
            "environment"        = "staging"
            "managed by"         = "terraform"
            "owner"              = "Greg Johnson"
        }
        # (11 unchanged attributes hidden)
    }

  # azurerm_virtual_desktop_host_pool.pooled_host_pool["STIN-AVD-Std"] must be replaced
-/+ resource "azurerm_virtual_desktop_host_pool" "pooled_host_pool" {
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-Std" -> (known after apply)
        name                             = "STIN-AVD-Std"
      ~ preferred_app_group_type         = "None" -> "Desktop" # forces replacement
        tags                             = {
            "Migrate Project"    = "INT-MigProject-01"
            "OffPeakConcurrency" = "1"
            "PeakConcurrency"    = "1"
            "domain"             = "intertel"
            "environment"        = "staging"
            "managed by"         = "terraform"
            "owner"              = "Greg Johnson"
        }
        # (11 unchanged attributes hidden)
    }

  # azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-MgP"] will be created
  + resource "azurerm_virtual_desktop_host_pool_registration_info" "pooled_host_pool_registration" {
      + expiration_date = (known after apply)
      + hostpool_id     = (known after apply)
      + id              = (known after apply)
      + token           = (sensitive value)
    }

  # azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-MgS"] will be created
  + resource "azurerm_virtual_desktop_host_pool_registration_info" "pooled_host_pool_registration" {
      + expiration_date = (known after apply)
      + hostpool_id     = (known after apply)
      + id              = (known after apply)
      + token           = (sensitive value)
    }

  # azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-PER"] will be created
  + resource "azurerm_virtual_desktop_host_pool_registration_info" "pooled_host_pool_registration" {
      + expiration_date = (known after apply)
      + hostpool_id     = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/hostPools/STIN-AVD-PER"
      + id              = (known after apply)
      + token           = (sensitive value)
    }

  # azurerm_virtual_desktop_host_pool_registration_info.pooled_host_pool_registration["STIN-AVD-Std"] will be created
  + resource "azurerm_virtual_desktop_host_pool_registration_info" "pooled_host_pool_registration" {
      + expiration_date = (known after apply)
      + hostpool_id     = (known after apply)
      + id              = (known after apply)
      + token           = (sensitive value)
    }

  # azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-MgP"] will be created
  + resource "azurerm_virtual_desktop_workspace_application_group_association" "pooled_host_pool_dag_ws_connect" {
      + application_group_id = (known after apply)
      + id                   = (known after apply)
      + workspace_id         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging"
    }

  # azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-MgS"] will be created
  + resource "azurerm_virtual_desktop_workspace_application_group_association" "pooled_host_pool_dag_ws_connect" {
      + application_group_id = (known after apply)
      + id                   = (known after apply)
      + workspace_id         = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging"
    }

  # azurerm_virtual_desktop_workspace_application_group_association.pooled_host_pool_dag_ws_connect["STIN-AVD-Std"] must be replaced
-/+ resource "azurerm_virtual_desktop_workspace_application_group_association" "pooled_host_pool_dag_ws_connect" {
      ~ application_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag" -> (known after apply) # forces replacement
      ~ id                   = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/workspaces/Intertel-Staging|/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.DesktopVirtualization/applicationGroups/STIN-AVD-Std-dag" -> (known after apply)
        # (1 unchanged attribute hidden)
    }

  # azurerm_virtual_machine.imported-vms["ST-UTILSRV01"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "imported-vms" {
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/ST-UTILSRV01"
        name                             = "ST-UTILSRV01"
      ~ tags                             = {
            "Migrate Project" = "INT-MigProject-01"
          - "Offline"         = "No" -> null
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (9 unchanged attributes hidden)

        # (2 unchanged blocks hidden)
    }

  # azurerm_virtual_machine_data_disk_attachment.vm-sql-disks-attach["logs"] will be created
  + resource "azurerm_virtual_machine_data_disk_attachment" "vm-sql-disks-attach" {
      + caching                   = "None"
      + create_option             = "Attach"
      + id                        = (known after apply)
      + lun                       = 2
      + managed_disk_id           = (known after apply)
      + virtual_machine_id        = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01"
      + write_accelerator_enabled = false
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-MgP-1"] will be created
  + resource "azurerm_virtual_machine_extension" "pooled_host_pool_domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STIN-AVD-MgP-1-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = <<-EOT
            {
                  "Name": "intertel.local",
                  "OUPath": "OU=Staging,OU=IN-AVD-MgP,OU=Azure AVD,OU=Azure,DC=intertel,DC=local",
                  "User": "svc.directoryservice@intertel.local",
                  "Restart": "true",
                  "Options": "3"
                }
        EOT
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-MgP-2"] will be created
  + resource "azurerm_virtual_machine_extension" "pooled_host_pool_domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STIN-AVD-MgP-2-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = <<-EOT
            {
                  "Name": "intertel.local",
                  "OUPath": "OU=Staging,OU=IN-AVD-MgP,OU=Azure AVD,OU=Azure,DC=intertel,DC=local",
                  "User": "svc.directoryservice@intertel.local",
                  "Restart": "true",
                  "Options": "3"
                }
        EOT
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_domain_join["STIN-AVD-MgS-1"] will be created
  + resource "azurerm_virtual_machine_extension" "pooled_host_pool_domain_join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STIN-AVD-MgS-1-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = <<-EOT
            {
                  "Name": "intertel.local",
                  "OUPath": "OU=Staging,OU=IN-AVD-MgS,OU=Azure AVD,OU=Azure,DC=intertel,DC=local",
                  "User": "svc.directoryservice@intertel.local",
                  "Restart": "true",
                  "Options": "3"
                }
        EOT
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-MgP-1"] will be created
  + resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STIN-AVD-MgP-1-dsc"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Powershell"
      + settings                    = jsonencode(
            {
              + configurationFunction = "Configuration.ps1\\AddSessionHost"
              + modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
              + properties            = {
                  + HostPoolName = "STIN-AVD-MgP"
                }
            }
        )
      + type                        = "DSC"
      + type_handler_version        = "2.73"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-MgP-2"] will be created
  + resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STIN-AVD-MgP-2-dsc"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Powershell"
      + settings                    = jsonencode(
            {
              + configurationFunction = "Configuration.ps1\\AddSessionHost"
              + modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
              + properties            = {
                  + HostPoolName = "STIN-AVD-MgP"
                }
            }
        )
      + type                        = "DSC"
      + type_handler_version        = "2.73"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-MgS-1"] will be created
  + resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STIN-AVD-MgS-1-dsc"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Powershell"
      + settings                    = jsonencode(
            {
              + configurationFunction = "Configuration.ps1\\AddSessionHost"
              + modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip"
              + properties            = {
                  + HostPoolName = "STIN-AVD-MgS"
                }
            }
        )
      + type                        = "DSC"
      + type_handler_version        = "2.73"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-PER-1"] will be updated in-place
  ~ resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
        id                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-PER-1/extensions/STIN-AVD-PER-1-dsc"
        name                        = "STIN-AVD-PER-1-dsc"
      ~ protected_settings          = (sensitive value)
        tags                        = {}
        # (8 unchanged attributes hidden)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-1"] will be updated in-place
  ~ resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
        id                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-1/extensions/STIN-AVD-Std-1-dsc"
        name                        = "STIN-AVD-Std-1-dsc"
      ~ protected_settings          = (sensitive value)
        tags                        = {}
        # (8 unchanged attributes hidden)
    }

  # azurerm_virtual_machine_extension.pooled_host_pool_dsc["STIN-AVD-Std-2"] will be updated in-place
  ~ resource "azurerm_virtual_machine_extension" "pooled_host_pool_dsc" {
        id                          = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-2/extensions/STIN-AVD-Std-2-dsc"
        name                        = "STIN-AVD-Std-2-dsc"
      ~ protected_settings          = (sensitive value)
        tags                        = {}
        # (8 unchanged attributes hidden)
    }

  # azurerm_virtual_machine_extension.vms-domain-join["STINB2-MGT01"] will be created
  + resource "azurerm_virtual_machine_extension" "vms-domain-join" {
      + auto_upgrade_minor_version  = true
      + failure_suppression_enabled = false
      + id                          = (known after apply)
      + name                        = "STINB2-MGT01-domain-join"
      + protected_settings          = (sensitive value)
      + publisher                   = "Microsoft.Compute"
      + settings                    = <<-EOT
            {
                  "Name": "intertel.local",
                  "OUPath": "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local",
                  "User": "svc.directoryservice@intertel.local",
                  "Restart": "true",
                  "Options": "3"
                }
        EOT
      + type                        = "JsonADDomainExtension"
      + type_handler_version        = "1.3"
      + virtual_machine_id          = (known after apply)
    }

  # azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-MgP-1"] will be created
  + resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
      + admin_password               = (sensitive value)
      + admin_username               = "ONTAdmin"
      + allow_extension_operations   = true
      + computer_name                = (known after apply)
      + enable_automatic_updates     = true
      + extensions_time_budget       = "PT1H30M"
      + hotpatching_enabled          = false
      + id                           = (known after apply)
      + location                     = "southcentralus"
      + max_bid_price                = -1
      + name                         = "STIN-AVD-MgP-1"
      + network_interface_ids        = (known after apply)
      + patch_assessment_mode        = "ImageDefault"
      + patch_mode                   = "AutomaticByOS"
      + platform_fault_domain        = -1
      + priority                     = "Regular"
      + private_ip_address           = (known after apply)
      + private_ip_addresses         = (known after apply)
      + provision_vm_agent           = true
      + proximity_placement_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
      + public_ip_address            = (known after apply)
      + public_ip_addresses          = (known after apply)
      + resource_group_name          = "int-staging-rg"
      + size                         = "Standard_B4ms"
      + source_image_id              = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-INT-Mgmt-Win10-img"
      + tags                         = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + timezone                     = "Central Standard Time"
      + virtual_machine_id           = (known after apply)

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = "stin-avd-mgp-1"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification (known after apply)
    }

  # azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-MgP-2"] will be created
  + resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
      + admin_password               = (sensitive value)
      + admin_username               = "ONTAdmin"
      + allow_extension_operations   = true
      + computer_name                = (known after apply)
      + enable_automatic_updates     = true
      + extensions_time_budget       = "PT1H30M"
      + hotpatching_enabled          = false
      + id                           = (known after apply)
      + location                     = "southcentralus"
      + max_bid_price                = -1
      + name                         = "STIN-AVD-MgP-2"
      + network_interface_ids        = (known after apply)
      + patch_assessment_mode        = "ImageDefault"
      + patch_mode                   = "AutomaticByOS"
      + platform_fault_domain        = -1
      + priority                     = "Regular"
      + private_ip_address           = (known after apply)
      + private_ip_addresses         = (known after apply)
      + provision_vm_agent           = true
      + proximity_placement_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
      + public_ip_address            = (known after apply)
      + public_ip_addresses          = (known after apply)
      + resource_group_name          = "int-staging-rg"
      + size                         = "Standard_B4ms"
      + source_image_id              = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-INT-Mgmt-Win10-img"
      + tags                         = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + timezone                     = "Central Standard Time"
      + virtual_machine_id           = (known after apply)

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = "stin-avd-mgp-2"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification (known after apply)
    }

  # azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-MgS-1"] will be created
  + resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
      + admin_password               = (sensitive value)
      + admin_username               = "ONTAdmin"
      + allow_extension_operations   = true
      + computer_name                = (known after apply)
      + enable_automatic_updates     = true
      + extensions_time_budget       = "PT1H30M"
      + hotpatching_enabled          = false
      + id                           = (known after apply)
      + location                     = "southcentralus"
      + max_bid_price                = -1
      + name                         = "STIN-AVD-MgS-1"
      + network_interface_ids        = (known after apply)
      + patch_assessment_mode        = "ImageDefault"
      + patch_mode                   = "AutomaticByOS"
      + platform_fault_domain        = -1
      + priority                     = "Regular"
      + private_ip_address           = (known after apply)
      + private_ip_addresses         = (known after apply)
      + provision_vm_agent           = true
      + proximity_placement_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
      + public_ip_address            = (known after apply)
      + public_ip_addresses          = (known after apply)
      + resource_group_name          = "int-staging-rg"
      + size                         = "Standard_B2ms"
      + source_image_id              = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-INT-Mgmt-Win10-img"
      + tags                         = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + timezone                     = "Central Standard Time"
      + virtual_machine_id           = (known after apply)

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = "stin-avd-mgs-1"
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + termination_notification (known after apply)
    }

  # azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-PER-1"] will be updated in-place
  ~ resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
        id                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-PER-1"
      - license_type                  = "Windows_Client" -> null
        name                          = "STIN-AVD-PER-1"
        tags                          = {
            "Migrate Project" = "INT-MigProject-01"
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (37 unchanged attributes hidden)

      - boot_diagnostics {
            # (1 unchanged attribute hidden)
        }

        # (2 unchanged blocks hidden)
    }

  # azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-1"] will be updated in-place
  ~ resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
        id                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-1"
      - license_type                  = "Windows_Client" -> null
        name                          = "STIN-AVD-Std-1"
      + proximity_placement_group_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
        tags                          = {
            "Migrate Project" = "INT-MigProject-01"
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (36 unchanged attributes hidden)

        # (2 unchanged blocks hidden)
    }

  # azurerm_windows_virtual_machine.pooled_host_pool_vms["STIN-AVD-Std-2"] will be updated in-place
  ~ resource "azurerm_windows_virtual_machine" "pooled_host_pool_vms" {
        id                            = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STIN-AVD-Std-2"
      - license_type                  = "Windows_Client" -> null
        name                          = "STIN-AVD-Std-2"
      + proximity_placement_group_id  = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
        tags                          = {
            "Migrate Project" = "INT-MigProject-01"
            "domain"          = "intertel"
            "environment"     = "staging"
            "managed by"      = "terraform"
            "owner"           = "Greg Johnson"
        }
        # (36 unchanged attributes hidden)

        # (2 unchanged blocks hidden)
    }

  # azurerm_windows_virtual_machine.vms["STINB2-MGT01"] will be created
  + resource "azurerm_windows_virtual_machine" "vms" {
      + admin_password               = (sensitive value)
      + admin_username               = "ONTAdmin"
      + allow_extension_operations   = true
      + computer_name                = (known after apply)
      + enable_automatic_updates     = false
      + extensions_time_budget       = "PT1H30M"
      + hotpatching_enabled          = false
      + id                           = (known after apply)
      + location                     = "southcentralus"
      + max_bid_price                = -1
      + name                         = "STINB2-MGT01"
      + network_interface_ids        = (known after apply)
      + patch_assessment_mode        = "ImageDefault"
      + patch_mode                   = "Manual"
      + platform_fault_domain        = -1
      + priority                     = "Regular"
      + private_ip_address           = (known after apply)
      + private_ip_addresses         = (known after apply)
      + provision_vm_agent           = true
      + proximity_placement_group_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
      + public_ip_address            = (known after apply)
      + public_ip_addresses          = (known after apply)
      + resource_group_name          = "int-staging-rg"
      + size                         = "Standard_B2ms"
      + tags                         = {
          + "Migrate Project" = "INT-MigProject-01"
          + "domain"          = "intertel"
          + "environment"     = "staging"
          + "managed by"      = "terraform"
          + "owner"           = "Greg Johnson"
        }
      + timezone                     = "Central Standard Time"
      + virtual_machine_id           = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = "STINB2-MGT01-disk-os"
          + storage_account_type      = "Premium_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "WindowsServer"
          + publisher = "MicrosoftWindowsServer"
          + sku       = "2019-Datacenter"
          + version   = "latest"
        }

      + termination_notification (known after apply)
    }

Plan: 38 to add, 14 to change, 8 to destroy.
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: 8c68644c-c9ff-4ea1-8d9f-7cd07c814a00 Correlation ID: c62cb326-ba4e-45f7-a5a6-a94b3765cee1 Timestamp: 2025-09-06 15:15:46Z","error_codes":[7000222],"timestamp":"2025-09-06 15:15:46Z","trace_id":"8c68644c-c9ff-4ea1-8d9f-7cd07c814a00","correlation_id":"c62cb326-ba4e-45f7-a5a6-a94b3765cee1","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].OntellusTenant,
│   on provider.tf line 26, in provider "azurerm":
│   26: provider "azurerm" {
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: 4bbbac92-ad74-4818-b75e-b7e025c33800 Correlation ID: 70c60b1d-25e6-43b5-9ce2-81e3f8d94d63 Timestamp: 2025-09-06 15:15:46Z","error_codes":[7000222],"timestamp":"2025-09-06 15:15:46Z","trace_id":"4bbbac92-ad74-4818-b75e-b7e025c33800","correlation_id":"70c60b1d-25e6-43b5-9ce2-81e3f8d94d63","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].RecordsXTenant,
│   on provider.tf line 37, in provider "azurerm":
│   37: provider "azurerm" {
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: 3f9d367c-7ecd-438f-a4e8-75ce352e1a00 Correlation ID: 561fc7bf-8e7e-42c4-83f2-ccfab96131b7 Timestamp: 2025-09-06 15:15:46Z","error_codes":[7000222],"timestamp":"2025-09-06 15:15:46Z","trace_id":"3f9d367c-7ecd-438f-a4e8-75ce352e1a00","correlation_id":"561fc7bf-8e7e-42c4-83f2-ccfab96131b7","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].OntellusProd1,
│   on provider.tf line 48, in provider "azurerm":
│   48: provider "azurerm" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:06866d79-001a-0063-2641-1f7eb7000000\nTime:2025-09-06T15:15:42.9856436Z"
│
│   with azurerm_storage_share.file_share["optifiles"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:46611d73-a01a-0018-4441-1f3c2b000000\nTime:2025-09-06T15:15:42.9892412Z"
│
│   with azurerm_storage_share.file_share["emailattachments"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:10e99125-f01a-0048-2941-1ffe7b000000\nTime:2025-09-06T15:15:42.9839803Z"
│
│   with azurerm_storage_share.file_share["tloxml"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:4928b564-601a-0065-0241-1f4d08000000\nTime:2025-09-06T15:15:42.9827141Z"
│
│   with azurerm_storage_share.file_share["reportgeneration"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:10e99127-f01a-0048-2a41-1ffe7b000000\nTime:2025-09-06T15:15:42.9961128Z"
│
│   with azurerm_storage_share.file_share["itdept"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:46611d75-a01a-0018-4541-1f3c2b000000\nTime:2025-09-06T15:15:43.0012207Z"
│
│   with azurerm_storage_share.file_share["humanresources"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:46611d76-a01a-0018-4641-1f3c2b000000\nTime:2025-09-06T15:15:43.0030427Z"
│
│   with azurerm_storage_share.file_share["clientapps"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:4b214f69-001a-0011-1441-1f79f8000000\nTime:2025-09-06T15:15:43.0179085Z"
│
│   with azurerm_storage_share.file_share["codocuments"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:10e99128-f01a-0048-2b41-1ffe7b000000\nTime:2025-09-06T15:15:42.9981060Z"
│
│   with azurerm_storage_share.file_share["netdata"],
│   on storage.tf line 36, in resource "azurerm_storage_share" "file_share":
│   36: resource "azurerm_storage_share" "file_share" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:31e7ee59-c01a-001d-6c41-1fab39000000\nTime:2025-09-06T15:15:49.0088458Z"
│
│   with azurerm_storage_share.file_storage_profiles["profiles01"],
│   on storage.tf line 109, in resource "azurerm_storage_share" "file_storage_profiles":
│  109: resource "azurerm_storage_share" "file_storage_profiles" {
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:594cf5cd-a01a-001b-6141-1f9886000000\nTime:2025-09-06T15:15:49.0075189Z"
│
│   with azurerm_storage_share.file_storage_profiles["mgmt"],
│   on storage.tf line 109, in resource "azurerm_storage_share" "file_storage_profiles":
│  109: resource "azurerm_storage_share" "file_storage_profiles" {
│
╵
╷
│ Error: reading Sql Virtual Machine (Subscription: "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
│ Resource Group Name: "int-staging-rg"
│ Sql Virtual Machine Name: "STINB2-SQL01"): sqlvirtualmachines.SqlVirtualMachinesClient#Get: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="VmNotRunning" Message="The VM: /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01 is not in running state."
│
│   with azurerm_mssql_virtual_machine.vm-sql,
│   on virtual-machines.tf line 224, in resource "azurerm_mssql_virtual_machine" "vm-sql":
│  224: resource "azurerm_mssql_virtual_machine" "vm-sql" {


















