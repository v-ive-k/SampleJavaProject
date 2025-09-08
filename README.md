az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az vm run-command invoke   --resource-group mr8-dev-rg   --name dvkib2-mrf01   --command-id RunPowerShellScript   --scripts '
    $targetLun = 0;
    $disk = Get-Disk | Where-Object { $_.Location -match "LUN $targetLun" };
    if (-not $disk) { throw "Disk with LUN $targetLun not found." };
    if ($disk.PartitionStyle -eq "RAW") {
      Initialize-Disk -Number $disk.Number -PartitionStyle GPT -Confirm:$false;
      $p = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter;
      Format-Volume -Partition $p -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false;
    } else {
      $p = Get-Partition -DiskNumber $disk.Number | Sort-Object Size -Descending | Select-Object -First 1;
    };
    $desired="E";
    if (-not (Get-Volume -DriveLetter $desired -ErrorAction SilentlyContinue)) {
      Set-Partition -DiskNumber $disk.Number -PartitionNumber $p.PartitionNumber -NewDriveLetter $desired -ErrorAction Stop;
    };
    Write-Host "Mounted as $desired:"
  '
(OperationNotAllowed) The operation requires the VM to be running (or set to run).
Code: OperationNotAllowed
Message: The operation requires the VM to be running (or set to run).
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az vm run-command invoke   --resource-group mr8-dev-rg   --name dvkib2-mrf01   --command-id RunPowerShellScript   --scripts '
    $targetLun = 0;
    $disk = Get-Disk | Where-Object { $_.Location -match "LUN $targetLun" };
    if (-not $disk) { throw "Disk with LUN $targetLun not found." };
    if ($disk.PartitionStyle -eq "RAW") {
      Initialize-Disk -Number $disk.Number -PartitionStyle GPT -Confirm:$false;
      $p = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter;
      Format-Volume -Partition $p -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false;
    } else {
      $p = Get-Partition -DiskNumber $disk.Number | Sort-Object Size -Descending | Select-Object -First 1;
    };
    $desired="E";
    if (-not (Get-Volume -DriveLetter $desired -ErrorAction SilentlyContinue)) {
      Set-Partition -DiskNumber $disk.Number -PartitionNumber $p.PartitionNumber -NewDriveLetter $desired -ErrorAction Stop;
    };
    Write-Host "Mounted as $desired:"
  '
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
      "message": "At C:\\Packages\\Plugins\\Microsoft.CPlat.Core.RunCommandWindows\\1.1.22\\Downloads\\script0.ps1:16 char:28\n+     Write-Host \"Mounted as $desired:\"\n+                            ~~~~~~~~~\nVariable reference is not valid. ':' was not followed by a valid variable name character. Consider using ${} to \ndelimit the name.\n    + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException\n    + FullyQualifiedErrorId : InvalidVariableReferenceWithDrive\n ",
      "time": null
    }
  ]
}
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ az vm run-command invoke -g mr8-dev-rg -n dvkib2-mrf01 \
  --command-id RunPowerShellScript \
  --scripts \
    'Get-Volume | Select DriveLetter,FileSystemLabel,FileSystem,Size,SizeRemaining | Sort DriveLetter' \
    'Get-Disk | Select Number,FriendlyName,Size,PartitionStyle,Location | Sort Number' \
    'Get-Partition | Select DiskNumber,PartitionNumber,DriveLetter,Size | Sort DiskNumber,PartitionNumber'
{
  "value": [
    {
      "code": "ComponentStatus/StdOut/succeeded",
      "displayStatus": "Provisioning succeeded",
      "level": "Info",
      "message": "DriveLetter     : \nFileSystemLabel : System Reserved\nFileSystem      : NTFS\nSize            : 524287488\nSizeRemaining   : 487547392\n\nDriveLetter     : C\nFileSystemLabel : Windows\nFileSystem      : NTFS\nSize            : 135839870976\nSizeRemaining   : 123219406848\n\nDriveLetter     : D\nFileSystemLabel : Temporary Storage\nFileSystem      : NTFS\nSize            : 17177767936\nSizeRemaining   : 15107883008\n\nNumber         : 0\nFriendlyName   : Virtual HD\nSize           : 137438953472\nPartitionStyle : MBR\nLocation       : PCI Slot 0 : Adapter 0 : Channel 0 : Device 0\n\nNumber         : 1\nFriendlyName   : Virtual HD\nSize           : 17179869184\nPartitionStyle : MBR\nLocation       : PCI Slot 1 : Adapter 0 : Channel 1 : Device 0\n\nNumber         : 2\nFriendlyName   : Msft Virtual Disk\nSize           : 137438953472\nPartitionStyle : RAW\nLocation       : Integrated : Bus 0 : Device 63667 : Function 30747 : Adapter 3 : Port 0 : Target 0 : LUN 0\n\nDiskNumber      : 0\nPartitionNumber : 1\nDriveLetter     : \u0000\nSize            : 524288000\n\nDiskNumber      : 0\nPartitionNumber : 2\nDriveLetter     : C\nSize            : 135839875072\n\nDiskNumber      : 1\nPartitionNumber : 1\nDriveLetter     : D\nSize            : 17177772032\n\n\n",
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
