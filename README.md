# === REMOVE OLD KUBELOGIN ===
Write-Host "Removing any old kubelogin binaries..."
$oldKubelogin = @(where kubelogin 2>$null)
foreach ($p in $oldKubelogin) {
    try { Remove-Item $p -Force -ErrorAction SilentlyContinue } catch {}
}
choco uninstall kubelogin -y 2>$null

# === DOWNLOAD & INSTALL AZURE KUBELOGIN ===
Write-Host "Downloading latest Azure kubelogin..."
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/Azure/kubelogin/releases/latest"
$asset = $release.assets | Where-Object { $_.name -match "kubelogin-win-amd64.zip" }
$zipUrl = $asset.browser_download_url

$dstDir = "C:\admin\bin"
$tempZip = "$env:TEMP\kubelogin.zip"

New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $dstDir -Force

# === UPDATE PATH ===
if (-not ($env:Path -split ';' | Where-Object { $_ -eq $dstDir })) {
    setx PATH "$($env:PATH);$dstDir" | Out-Null
}
$env:Path = "$env:Path;$dstDir"

# === VERIFY INSTALL ===
Write-Host "kubelogin version:" -ForegroundColor Cyan
kubelogin --version
Write-Host "kubelogin help (checking convert-kubeconfig):" -ForegroundColor Cyan
kubelogin --help | Select-String "convert-kubeconfig"

# === LOGIN TO AZURE ===
az login

# === GET AKS CREDENTIALS ===
$ResourceGroup = "<RESOURCE_GROUP>"
$ClusterName   = "<CLUSTER_NAME>"
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName --overwrite-existing

# === CONVERT KUBECONFIG TO USE AZURE CLI ===
kubelogin convert-kubeconfig --login azurecli

# === TEST CONNECTION ===
kubectl config current-context
kubectl get nodes
kubectl get pods -A