$firewall = Get-AzFirewall -name "<firewall-name>" -resourcegroupname "<resource-group-name>"

$firewall.firewallpolicy = $null

echo "Deallocating..."
$firewall.deallocate()
$firewall | set-azfirewall

