$firewall = Get-AzFirewall -name microsave-firewall -resourcegroupname microsave-hub-resourcegroup

$firewall.firewallpolicy = $null

echo "Deallocating..."
$firewall.deallocate()
$firewall | set-azfirewall

