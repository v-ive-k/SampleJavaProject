Plan: 0 to add, 7 to change, 108 to destroy.
╷
│ Error: reading Sql Virtual Machine (Subscription: "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
│ Resource Group Name: "int-staging-rg"
│ Sql Virtual Machine Name: "STINB2-SQL01"): sqlvirtualmachines.SqlVirtualMachinesClient#Get: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="VmNotRunning" Message="The VM: /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01 is not in running state."
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f514ab-301a-000a-297f-2047fb000000\nTime:2025-09-08T05:13:18.5290779Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f514af-301a-000a-2d7f-2047fb000000\nTime:2025-09-08T05:13:19.1738222Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f5149b-301a-000a-277f-2047fb000000\nTime:2025-09-08T05:13:18.3831676Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f514aa-301a-000a-287f-2047fb000000\nTime:2025-09-08T05:13:18.5270971Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:2fc2b941-401a-005e-667f-204d65000000\nTime:2025-09-08T05:13:18.5071047Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f51496-301a-000a-247f-2047fb000000\nTime:2025-09-08T05:13:18.1489915Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f514ae-301a-000a-2c7f-2047fb000000\nTime:2025-09-08T05:13:19.0410585Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f514ac-301a-000a-2a7f-2047fb000000\nTime:2025-09-08T05:13:18.6617931Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f51498-301a-000a-257f-2047fb000000\nTime:2025-09-08T05:13:18.1601158Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:2fc2b944-401a-005e-677f-204d65000000\nTime:2025-09-08T05:13:18.5252281Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c1f51499-301a-000a-267f-2047fb000000\nTime:2025-09-08T05:13:18.2555930Z"
│
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: d3b46088-89dd-4395-8ee0-b38d55df4b02 Correlation ID: 0e82e9bb-8281-446d-a005-1d1d06b4d829 Timestamp: 2025-09-08 05:13:24Z","error_codes":[7000222],"timestamp":"2025-09-08 05:13:24Z","trace_id":"d3b46088-89dd-4395-8ee0-b38d55df4b02","correlation_id":"0e82e9bb-8281-446d-a005-1d1d06b4d829","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].OntellusTenant,
│   on provider.tf line 26, in provider "azurerm":
│   26: provider "azurerm" {
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: ddf1c674-cf30-4701-b7d7-beb3258c9e02 Correlation ID: 731181e5-392b-4b6e-b319-c786de96119a Timestamp: 2025-09-08 05:13:24Z","error_codes":[7000222],"timestamp":"2025-09-08 05:13:24Z","trace_id":"ddf1c674-cf30-4701-b7d7-beb3258c9e02","correlation_id":"731181e5-392b-4b6e-b319-c786de96119a","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].RecordsXTenant,
│   on provider.tf line 37, in provider "azurerm":
│   37: provider "azurerm" {
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: 2e3b69ed-7a7e-47c9-aa76-05137ca5f501 Correlation ID: 3b2d59ea-7150-4214-b63b-2e7416c23054 Timestamp: 2025-09-08 05:13:24Z","error_codes":[7000222],"timestamp":"2025-09-08 05:13:24Z","trace_id":"2e3b69ed-7a7e-47c9-aa76-05137ca5f501","correlation_id":"3b2d59ea-7150-4214-b63b-2e7416c23054","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].OntellusProd1,
│   on provider.tf line 48, in provider "azurerm":
│   48: provider "azurerm" {
│
╵
╷
│ Error: Invalid value for input variable
│
│   on terraform.tfvars line 387:
│  387: sql_settings            = {} # map/object – left empty
│
│ The given value is not suitable for var.sql_settings declared at variables.tf:54,1-24: attributes "data_disks" and "server_name" are required.
╵
╷
│ Error: Invalid value for input variable
│
│   on terraform.tfvars line 408:
│  408: virtual_machines = [
│  409:   {
│  410:     name                = "STINB2-UTL01"
│  411:     location            = "southcentralus"
│  412:     resource_group_name = "int-staging-rg"
│  413:     # Use the same subnet as ST-UTILSRV01. In your state you have:
│  414:     # azurerm_subnet.internal_snet  (most likely the utils server lived here)
│  415:     # subnet_id = azurerm_subnet.internal_snet.id
│  416:     size           = "Standard_B2ms"
│  417:     admin_username = "ONTAdmin"
│  418:     # admin_password = data.azurerm_key_vault_secret.ontadmin.value
│  419:     # Platform image (new OS disk auto-created)
│  420:     source_image = {
│  421:       publisher = "MicrosoftWindowsServer"
│  422:       offer     = "WindowsServer"
│  423:       sku       = "2019-Datacenter"
│  424:       version   = "latest"
│  425:     }
│  426:     # Optional, only if your VM code reads it:
│  427:     # ppg_id = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/proximityPlacementGroups/int-stg-ppg"
│  428:     # Domain join — mirrors the old extension settings
│  429:     domain_join = {
│  430:       enabled = true
│  431:       domain  = "intertel.local"
│  432:       ou_path = "OU=Staging,OU=Azure Servers,OU=Azure,DC=intertel,DC=local"
│  433:       user    = "svc.directoryservice@intertel.local"
│  434:     }
│  435:     # Optional explicit OS disk controls (only if your code supports this block):
│  436:     # os_disk = {
│  437:     #   storage_account_type = "Premium_LRS"
│  438:     #   disk_size_gb         = 128
│  439:     #   caching              = "ReadWrite"
│  440:     # }
│  441:     # tags (if your module lets you override)
│  442:     tags = {
│  443:       "Migrate Project" = "INT-MigProject-01"
│  444:       "domain"          = "intertel"
│  445:       "environment"     = "staging"
│  446:       "managed by"      = "terraform"
│  447:       "owner"           = "Greg Johnson"
│  448:     }
│  449:   }
│  450: ]
│
│ The given value is not suitable for var.virtual_machines declared at variables.tf:26,1-28: element 0: attribute "ou_path" is required.
