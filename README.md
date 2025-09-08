Plan: 3 to add, 7 to change, 119 to destroy.
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3a8-701a-0024-2b82-2015ec000000\nTime:2025-09-08T05:33:50.8880060Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3c2-701a-0024-3d82-2015ec000000\nTime:2025-09-08T05:33:52.4117695Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3a9-701a-0024-2c82-2015ec000000\nTime:2025-09-08T05:33:50.8897368Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c3504aff-f01a-0039-0e82-205d99000000\nTime:2025-09-08T05:33:50.8361964Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:c3504b02-f01a-0039-0f82-205d99000000\nTime:2025-09-08T05:33:51.0602953Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3ad-701a-0024-3082-2015ec000000\nTime:2025-09-08T05:33:51.0796317Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3ab-701a-0024-2e82-2015ec000000\nTime:2025-09-08T05:33:50.9538850Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3af-701a-0024-3282-2015ec000000\nTime:2025-09-08T05:33:51.5468207Z"
│
│
╵
╷
│ Error: reading Sql Virtual Machine (Subscription: "ffe5c17f-a5cd-46d5-8137-b8c02ee481af"
│ Resource Group Name: "int-staging-rg"
│ Sql Virtual Machine Name: "STINB2-SQL01"): sqlvirtualmachines.SqlVirtualMachinesClient#Get: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="VmNotRunning" Message="The VM: /subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/int-staging-rg/providers/Microsoft.Compute/virtualMachines/STINB2-SQL01 is not in running state."
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3bf-701a-0024-3b82-2015ec000000\nTime:2025-09-08T05:33:52.3478424Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3a1-701a-0024-2882-2015ec000000\nTime:2025-09-08T05:33:50.6828890Z"
│
│
╵
╷
│ Error: shares.Client#GetProperties: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailure" Message="This request is not authorized to perform this operation.\nRequestId:7b36a3a7-701a-0024-2a82-2015ec000000\nTime:2025-09-08T05:33:50.8834676Z"
│
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: 033f1eff-e30f-463d-b628-c78efccbd700 Correlation ID: 3bf127fb-18de-4cf0-b8ef-10e6df78abd6 Timestamp: 2025-09-08 05:33:54Z","error_codes":[7000222],"timestamp":"2025-09-08 05:33:54Z","trace_id":"033f1eff-e30f-463d-b628-c78efccbd700","correlation_id":"3bf127fb-18de-4cf0-b8ef-10e6df78abd6","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].OntellusTenant,
│   on provider.tf line 26, in provider "azurerm":
│   26: provider "azurerm" {
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: a34c27c4-0b04-44f5-a26c-2b2cd7a76500 Correlation ID: 2dc03c24-6a3e-4f7d-a37e-6e49afdae7e7 Timestamp: 2025-09-08 05:33:54Z","error_codes":[7000222],"timestamp":"2025-09-08 05:33:54Z","trace_id":"a34c27c4-0b04-44f5-a26c-2b2cd7a76500","correlation_id":"2dc03c24-6a3e-4f7d-a37e-6e49afdae7e7","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].RecordsXTenant,
│   on provider.tf line 37, in provider "azurerm":
│   37: provider "azurerm" {
│
╵
╷
│ Error: building account: could not acquire access token to parse claims: clientCredentialsToken: received HTTP status 401 with response: {"error":"invalid_client","error_description":"AADSTS7000222: The provided client secret keys for app '3f31972c-b59f-480d-b4f3-71d39043b74e' are expired. Visit the Azure portal to create new keys for your app: https://aka.ms/NewClientSecret, or consider using certificate credentials for added security: https://aka.ms/certCreds. Trace ID: b6117927-495d-4e18-aa79-29ff45585202 Correlation ID: d915d35e-7a8c-4a19-b407-58e971bb0baa Timestamp: 2025-09-08 05:33:54Z","error_codes":[7000222],"timestamp":"2025-09-08 05:33:54Z","trace_id":"b6117927-495d-4e18-aa79-29ff45585202","correlation_id":"d915d35e-7a8c-4a19-b407-58e971bb0baa","error_uri":"https://login.microsoftonline.com/error?code=7000222"}
│
│   with provider["registry.terraform.io/hashicorp/azurerm"].OntellusProd1,
│   on provider.tf line 48, in provider "azurerm":
│   48: provider "azurerm" {
│
╵
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/int-staging-rg$
