$rel = Invoke-RestMethod https://api.github.com/repos/Azure/kubelogin/releases/latest
$zip = ($rel.assets | Where-Object {$_.name -match 'kubelogin-win-amd64.zip'}).browser_download_url
$dst = "C:\admin\bin"
$temp = "$env:TEMP\kubelogin.zip"

New-Item -ItemType Directory -Force -Path $dst | Out-Null
Invoke-WebRequest -Uri $zip -OutFile $temp
Expand-Archive -Path $temp -DestinationPath $dst -Force

# ensure PATH contains C:\admin\bin
if (-not ($env:Path -split ';' | Where-Object { $_ -eq $dst })) {
  setx PATH "$($env:PATH);$dst" | Out-Null
}
$env:Path = "$env:Path;$dst"




where kubelogin
kubelogin --help | Select-String -SimpleMatch "convert-kubeconfig"
# You should see usage that includes:  convert-kubeconfig --login azurecli



az login
az aks get-credentials --resource-group <RESOURCE_GROUP> --name <CLUSTER_NAME> --overwrite-existing
kubelogin convert-kubeconfig --login azurecli
kubectl get nodes
kubectl get pods -A



where kubelogin
# delete any leftover copies not in C:\admin\bin


kubectl config current-context
kubectl version --client
kubelogin --version

