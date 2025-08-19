terraform import \
  -var-file=dev.tfvars \
  azurerm_resource_group.rg \
  /subscriptions/<SUBID>/resourceGroups/<RG-NAME>
