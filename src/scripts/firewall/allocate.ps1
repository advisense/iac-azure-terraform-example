$firewall = Get-AzFirewall -name microsave-firewall -resourcegroupname microsave-hub-resourcegroup
$vnet = Get-AzVirtualNetwork -name microsave-hub-vnet -resourcegroupname microsave-hub-resourcegroup

$publicip = get-azpublicipaddress -name microsave-firewall-public-ip-pip02 -resourcegroupname microsave-hub-resourcegroup
$publicipmgmt = get-azpublicipaddress -name microsave-firewall-management-public-ip-pip04 -resourcegroupname microsave-hub-resourcegroup

$firewallpolicy = Get-AzFirewallPolicy -name microsave-firwall-policy-pol01 -ResourceGroupName microsave-hub-resourcegroup

$firewall.firewallpolicy = $firewallpolicy.id
$firewall.allocate($vnet, $publicip, $publicipmgmt)
echo "Allocating..."
$firewall | set-azfirewall
