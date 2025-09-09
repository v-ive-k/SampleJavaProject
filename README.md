
az vm show \
  --name STINB2-SQL01 \
  --resource-group <replace-your-rg-name> \
  --query "storageProfile.dataDisks" -o table
