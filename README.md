# ==== silence everything we’re not using ====
AVD_shared_tags                 = {}
AVD_tags                        = {}

avd_snet_address_prefix         = "10.239.0.0/24"     # any CIDR; not used
dmz_snet_address_prefix         = "10.239.1.0/24"     # any CIDR; not used
internal_snet_address_prefix    = "10.239.2.0/24"     # any CIDR; not used
mgmt_snet_address_prefix        = "10.239.3.0/24"     # any CIDR; not used
main_vnet_address_space         = ["10.239.0.0/16"]   # any CIDR; not used

domain_controller_ips           = []                  # list(string)
file_profiles                   = {}                  # map(...), left empty
file_profiles_contributor_group_id = ""
file_shares                     = {}                  # map(...), left empty
file_shares_contributor_group_id = ""

# If your variables.tf defines host_pool as a map/object this {} is correct.
# If it's a bool, change this to: false
host_pool                       = {}

mgmt_ips                        = {}                  # map(string) or map(object) – empty is fine
net_services                    = {}                  # map(object) – empty is fine
rg_contributor_group_id         = ""
rg_owner_group_id               = ""
rg_reader_group_id              = ""
server_names                    = {}                  # map(string) – empty okay
sql_settings                    = {}                  # map/object – left empty

stg_workspace                   = false
stg_workspace_description       = ""
stg_workspace_friendly          = ""

# global tags still used elsewhere
tags = {
  domain       = "intertel"
  environment  = "staging"
  "managed by" = "terraform"
}

# ==== only the new utility VM ====
# Uses Internal subnet + your existing PPG. Clean Windows Server image.
vms = {
  STINB2-UTL01 = {
    location            = "southcentralus"
    resource_group_name = "int-staging-rg"

    subnet_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Network/virtualNetworks/intertel-staging-scus-vnet/subnets/intertel-staging-internal-scus-snet"

    size = "Standard_B2ms"

    # If your VM code expects "source_image_reference" instead, rename the key.
    source_image = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    ppg_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"

    domain_join = {
      enabled = true
      domain  = "intertel.local"
      ou_path = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
      user    = "svc.directoryservice@intertel.local"
    }

    tags = {
      "Migrate Project" = "INT-MigProject-01"
      domain            = "intertel"
      environment       = "staging"
      "managed by"      = "terraform"
      owner             = "Greg Johnson"
    }
  }
}

# Keep AVD things empty so no host pools/session hosts get created
avd_host_pools    = {}
avd_session_hosts = {}
