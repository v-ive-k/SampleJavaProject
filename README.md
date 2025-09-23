# Replace "Ethernet" with your network interface name from Get-NetAdapter
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","8.8.4.4")
