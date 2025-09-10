systeminfo | findstr /i "Hyper-V Requirements"
# You want all "Yes" (or “A hypervisor has been detected…”)

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V-All /all /norestart
dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart

# Ensure the hypervisor actually starts
bcdedit /set hypervisorlaunchtype auto

# Make sure compute + networking services are up
Start-Service vmcompute -ErrorAction SilentlyContinue
Start-Service hns -ErrorAction SilentlyContinue




wsl --update
wsl --set-default-version 2
wsl --install --web-download -d Ubuntu
