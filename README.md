az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az vm run-command invoke \
  -g mr8-dev-rg -n dvkib2-mrf01 \
  --command-id RunPowerShellScript \
  --scripts "
    \$targetLun = 0
    \$disk = Get-Disk | Where-Object { \$_.Location -match 'LUN \$targetLun' }
    if (-not \$disk) { throw 'Disk with LUN \$targetLun not found.' }

    if (\$disk.PartitionStyle -eq 'RAW') {
      Initialize-Disk -Number \$disk.Number -PartitionStyle GPT -Confirm:\$false
      \$p = New-Partition -DiskNumber \$disk.Number -UseMaximumSize -AssignDriveLetter
      Format-Volume -Partition \$p -FileSystem NTFS -NewFileSystemLabel 'Data' -Confirm:\$false
    } else {
      \$p = Get-Partition -DiskNumber \$disk.Number | Sort-Object Size -Descending | Select-Object -First 1
    }

    \$desired = 'E'
    if (-not (Get-Volume -DriveLetter \$desired -ErrorAction SilentlyContinue)) {
      Set-Partition -DiskNumber \$disk.Number -PartitionNumber \$p.PartitionNumber -NewDriveLetter \$desired -ErrorAction Stop
    }

    Write-Host ('Mounted as {0}:' -f \$desired)
  "
{
  "value": [
    {
      "code": "ComponentStatus/StdOut/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "",
      "time": null
    },
    {
      "code": "ComponentStatus/StdErr/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "Disk with LUN $targetLun not found.\nAt C:\\Packages\\Plugins\\Microsoft.CPlat.Core.RunCommandWindows\\1.1.22\\Downloads\\script2.ps1:4 char:23\n+     if (-not $disk) { throw 'Disk with LUN $targetLun not found.' }\n+                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n    + CategoryInfo          : OperationStopped: (Disk with LUN $targetLun not found.:String) [], RuntimeException\n    + FullyQualifiedErrorId : Disk with LUN $targetLun not found.\n ",
      "time": null
    }
  ]
}
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az vm run-command invoke -g mr8-dev-rg -n dvkib2-mrf01 \
  --command-id RunPowerShellScript \
  --scripts \
'Get-Volume | Select DriveLetter,FileSystemLabel,FileSystem,Size | Sort DriveLetter' \
'Get-Partition | Select DiskNumber,PartitionNumber,DriveLetter,Size | Sort DiskNumber,PartitionNumber'
{
  "value": [
    {
      "code": "ComponentStatus/StdOut/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "DriveLetter FileSystemLabel   FileSystem         Size\n----------- ---------------   ----------         ----\n            System Reserved   NTFS          524287488\nC           Windows           NTFS       135839870976\nD           Temporary Storage NTFS        17177767936\n\u0000                                           524288000\nC                                        135839875072\nD                                         17177772032\n\n",
      "time": null
    },
    {
      "code": "ComponentStatus/StdErr/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "",
      "time": null
    }
  ]
}
