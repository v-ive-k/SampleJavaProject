# keep your other maps empty/unchanged so nothing else is created
avd_host_pools   = {}
avd_session_hosts = {}

# ADD or REPLACE just this entry under your existing vms map
vms = {
  STINB2-UTL01 = {
    location            = "southcentralus"
    resource_group_name = "int-staging-rg"

    # Use the same subnet as ST-UTILSRV01. In your state you have:
    # azurerm_subnet.internal_snet  (most likely the utils server lived here)
    subnet_id = azurerm_subnet.internal_snet.id

    size           = "Standard_B2ms"
    admin_username = "ONTAdmin"
    admin_password = data.azurerm_key_vault_secret.ontadmin.value

    # Platform image (new OS disk auto-created)
    source_image = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    # Optional, only if your VM code reads it:
    # ppg_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"

    # Domain join — mirrors the old extension settings
    domain_join = {
      enabled = true
      domain  = "intertel.local"
      ou_path = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
      user    = "svc.directoryservice@intertel.local"
    }

    # Optional explicit OS disk controls (only if your code supports this block):
    # os_disk = {
    #   storage_account_type = "Premium_LRS"
    #   disk_size_gb         = 128
    #   caching              = "ReadWrite"
    # }

    # tags (if your module lets you override)
    # tags = {
    #   "Migrate Project" = "INT-MigProject-01"
    #   "domain"          = "intertel"
    #   "environment"     = "staging"
    #   "managed by"      = "terraform"
    #   "owner"           = "Greg Johnson"
    # }
  }
}

