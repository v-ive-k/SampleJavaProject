# ====== CLEAN OLD KUBELOGIN ======
Write-Host "Removing old kubelogin binaries..."
$oldPaths = @(where kubelogin 2>$null)
foreach ($p in $oldPaths) {
    try { Remove-Item $p -Force -ErrorAction SilentlyContinue } catch {}
}
choco uninstall kubelogin -y 2>$null

# ====== INSTALL CORRECT AZURE KUBELOGIN ======
Write-Host "Downloading Azure kubelogin..."
$rel = Invoke-RestMethod https://api.github.com/repos/Azure/kubelogin/releases/latest
$zip = ($rel.assets | Where-Object {$_.name -match 'kubelogin-win-amd64.zip'}).browser_download_url
$dst = "C:\admin\bin"
$temp = "$env:TEMP\kubelogin.zip"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Invoke-WebRequest -Uri $zip -OutFile $temp
Expand-Archive -Path $temp -DestinationPath $dst -Force

# ====== UPDATE PATH ======
if (-not ($env:Path -split ';' | Where-Object { $_ -eq $dst })) {
    setx PATH "$($env:PATH);$dst" | Out-Null
}
$env:Path = "$env:Path;$dst"

# ====== VERIFY ======
Write-Host "kubelogin version:"
kubelogin --version
Write-Host "kubelogin help contains convert-kubeconfig? "
kubelogin --help | Select-String -SimpleMatch "convert-kubeconfig"

# ====== LOGIN TO AZURE ======
Write-Host "Logging into Azure..."
az login

# ====== GET AKS CREDENTIALS ======
$ResourceGroup = "<RESOURCE_GROUP>"
$ClusterName = "<CLUSTER_NAME>"
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName --overwrite-existing

# ====== CONVERT KUBECONFIG ======
kubelogin convert-kubeconfig --login azurecli

# ====== TEST ======
kubectl config current-context
kubectl get nodes
kubectl get pods -A