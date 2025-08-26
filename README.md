az vm show \
  --resource-group <rg-name> \
  --name <vm-name> \
  --query "{computerName: osProfile.computerName, adminUsername: osProfile.adminUsername, windowsConfig: osProfile.windowsConfiguration}" \
  -o json
