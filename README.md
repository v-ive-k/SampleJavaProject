# (VM must be running)
az vm start -g mr8-dev-rg -n dvkib2-mrf01

az vm run-command invoke \
  -g mr8-dev-rg -n dvkib2-mrf01 \
  --command-id RunPowerShellScript \
  --scripts '
$targetLun = 0
$disk = Get-Disk | Where-Object { $_.Location -match "LUN $targetLun" }
if (-not $disk) { throw "Disk with LUN $targetLun not found." }

if ($disk.PartitionStyle -eq "RAW") {
  Initialize-Disk -Number $disk.Number -PartitionStyle GPT -Confirm:$false
  $p = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
  Format-Volume -Partition $p -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false
} else {
  $p = Get-Partition -DiskNumber $disk.Number | Sort-Object Size -Descending | Select-Object -First 1
}

$desired = "E"
if (-not (Get-Volume -DriveLetter $desired -ErrorAction SilentlyContinue)) {
  Set-Partition -DiskNumber $disk.Number -PartitionNumber $p.PartitionNumber -NewDriveLetter $desired -ErrorAction Stop
}

Write-Host ("Mounted as {0}:" -f $desired)
'





az vm run-command invoke -g mr8-dev-rg -n dvkib2-mrf01 \
  --command-id RunPowerShellScript \
  --scripts \
'Get-Volume | Select DriveLetter,FileSystemLabel,FileSystem,Size | Sort DriveLetter' \
'Get-Partition | Select DiskNumber,PartitionNumber,DriveLetter,Size | Sort DiskNumber,PartitionNumber'
