"dvkiwgb2_web03" = {
  name           = "dvkiwgb2-web03-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web04" = {
  name           = "dvkiwgb2-web04-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkiwgb2_web05" = {
  name           = "dvkiwgb2-web05-nic"
  subnet_key     = "dmz"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
},
"dvkib2_dts01" = {
  name           = "dvkib2-dts01-nic"
  subnet_key     = "internal"
  allocation     = "Dynamic"
  private_ip     = ""
  ip_config_name = "ipconfig1"
}








"dvkiwgb2_web03" = {
  name                 = "DVKIWGB2-WEB03_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web04" = {
  name                 = "DVKIWGB2-WEB04_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkiwgb2_web05" = {
  name                 = "DVKIWGB2-WEB05_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
},
"dvkib2_dts01" = {
  name                 = "DVKIB2-DTS01_OsDisk"
  disk_size_gb         = 127
  storage_account_type = "Premium_LRS"
  os_type              = "Windows"
  hyper_v_generation   = "V2"
}







"dvkiwgb2_web03" = {
  name                    = "dvkiwgb2-web03"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web03"
  os_disk_key             = "dvkiwgb2_web03"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← pulls from KV 'ontadmin'
    computer_name  = "DVKIWGB2-WEB03"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # DMZ: usually NOT domain joined → omit join_domain
},

"dvkiwgb2_web04" = {
  name                    = "dvkiwgb2-web04"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web04"
  os_disk_key             = "dvkiwgb2_web04"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB04"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkiwgb2_web05" = {
  name                    = "dvkiwgb2-web05"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkiwgb2_web05"
  os_disk_key             = "dvkiwgb2_web05"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""
    computer_name  = "DVKIWGB2-WEB05"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
},

"dvkib2_dts01" = {
  name                    = "dvkib2-dts01"
  size                    = "Standard_B2ms"
  nic_key                 = "dvkib2_dts01"
  os_disk_key             = "dvkib2_dts01"
  boot_diag_uri           = ""
  identity_type           = ""
  os_disk_creation_option = "FromImage"
  image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  os_profiles = {
    admin_username = "ONTAdmin"
    admin_password = ""                  # ← KV 'ontadmin'
    computer_name  = "DVKIB2-DTS01"
  }
  windows_config = {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  # Internal → domain join ON
  join_domain = true
  ou_path     = "OU=Servers,OU=Azure,DC=KEAISINC,DC=COM"
}



=====================================


az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ Resolve-DnsName ontdevinfraterraform.blob.core.windows.net
Resolve-DnsName: command not found
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ Test-NetConnection ontdevinfraterraform.blob.core.windows.net -Port 443
Test-NetConnection: command not found
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ ipconfig /all | findstr /i "DNS Servers"
Command 'ipconfig' not found, did you mean:
  command 'iwconfig' from deb wireless-tools (30~pre9-13.1ubuntu4)
  command 'ifconfig' from deb net-tools (1.60+git20181103.0eebece-1ubuntu5.4)
  command 'iconfig' from deb ipmiutil (3.1.8-1)
Try: sudo apt install <deb name>
findstr: command not found
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ nc -zv ontdevinfraterraform.blob.core.windows.net 443
Connection to ontdevinfraterraform.blob.core.windows.net (20.209.27.231) 443 port [tcp/https] succeeded!
az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ dig ontdevinfraterraform.blob.core.windows.net

; <<>> DiG 9.18.30-0ubuntu0.22.04.2-Ubuntu <<>> ontdevinfraterraform.blob.core.windows.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 39984
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;ontdevinfraterraform.blob.core.windows.net. IN A

;; ANSWER SECTION:
ontdevinfraterraform.blob.core.windows.net. 30 IN CNAME blob.sat11prdstr05a.store.core.windows.net.
blob.sat11prdstr05a.store.core.windows.net. 73650 IN A 20.209.27.231

;; Query time: 42 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)
;; WHEN: Thu Sep 04 12:17:56 CDT 2025
;; MSG SIZE  rcvd: 127

az-admin@ONT-Infra-23:/mnt/c/Users/VKovi/azure-infra/subscriptions/Ont-Dev1/mr8-dev-rg$ cat /etc/resolv.conf
# This file was automatically generated by WSL. To stop automatic generation of this file, add the following entry to /etc/wsl.conf:
# [network]
# generateResolvConf = false
nameserver 10.255.255.254
search reddog.microsoft.com
