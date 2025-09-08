az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/int-staging-rg$ terraform plan
var.AVD_shared_tags
  Enter a value:

var.AVD_tags
  Enter a value:

var.avd_snet_address_prefix
  Enter a value:

var.dmz_snet_address_prefix
  Enter a value:

var.domain_controller_ips
  list of IP addresses to domain controllers

  Enter a value:

var.file_profiles
  Enter a value:

var.file_profiles_contributor_group_id
  Enter a value:

var.file_shares
  Enter a value:

var.file_shares_contributor_group_id
  Enter a value:

var.host_pool
  Enter a value:

var.internal_snet_address_prefix
  Enter a value:

var.main_vnet_address_space
  Enter a value:

var.mgmt_ips
  Map of management PC names and IP addresses

  Enter a value:

var.mgmt_snet_address_prefix
  Enter a value:

var.net_services
  Map of network services associated with port numbers. Protocol is to help user determine how to set up rule. It is not used otherwise yet.

  Enter a value:

var.rg_contributor_group_id
  Enter a value:

var.rg_owner_group_id
  Enter a value:

var.rg_reader_group_id
  Enter a value:

var.server_names
  Names assigned to servers. These may need to be changed between environments (dev, staging, prod, etc)

  Enter a value:

var.sql_settings
  Enter a value:

var.stg_workspace
  Create Workspace for AVD pools

  Enter a value:

var.stg_workspace_description
  Portal workspace discription

  Enter a value:

var.stg_workspace_friendly
  The name seein in the client

  Enter a value:

var.tags
  Enter a value:

╷
│ Error: Missing expression
│
│   on <value for var.domain_controller_ips> line 1:
│   (source code not available)
│
│ Expected the start of an expression, but found the end of the file.
╵
╷
│ Error: Missing expression
│
│   on <value for var.mgmt_ips> line 1:
│   (source code not available)
│
│ Expected the start of an expression, but found the end of the file.
╵
╷
│ Error: Missing expression
│
│   on <value for var.net_services> line 1:
│   (source code not available)
│
│ Expected the start of an expression, but found the end of the file.
╵
╷
│ Error: Missing expression
│
│   on <value for var.server_names> line 1:
│   (source code not available)
│
│ Expected the start of an expression, but found the end of the file.
╵
╷
│ Error: Missing expression
│
│   on <value for var.sql_settings> line 1:
│   (source code not available)
│
│ Expected the start of an expression, but found the end of the file.
╵
╷
│ Error: No value for required variable
│
│   on variables.tf line 54:
│   54: variable "sql_settings" {
│
│ The root module input variable "sql_settings" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this variable.
╵
╷
│ Error: No value for required variable
│
│   on variables.tf line 113:
│  113: variable "domain_controller_ips" {
│
│ The root module input variable "domain_controller_ips" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this variable.
╵
╷
│ Error: No value for required variable
│
│   on variables.tf line 117:
│  117: variable "mgmt_ips" {
│
│ The root module input variable "mgmt_ips" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this variable.
╵
╷
│ Error: No value for required variable
│
│   on variables.tf line 124:
│  124: variable "server_names" {
│
│ The root module input variable "server_names" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this variable.
╵
╷
│ Error: No value for required variable
│
│   on variables.tf line 128:
│  128: variable "net_services" {
│
│ The root module input variable "net_services" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this variable.
╵
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/int-staging-rg$
