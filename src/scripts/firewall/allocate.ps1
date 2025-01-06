$firewall = Get-AzFirewall -name "az-conn-prod-noeast-afw" -resourcegroupname "<resource-group-name>"
$vnet = Get-AzVirtualNetwork -name "az-conn-prod-noeast-vnet" -resourcegroupname "<resource-group-name>"

$publicip = get-azpublicipaddress -name "<firewall-publicip-name>" -resourcegroupname "<resource-group-name>"
$publicipmgmt = get-azpublicipaddress -name "<firewall-mgmt-publicip-name>" -resourcegroupname "<resource-group-name>"

$firewallpolicy = Get-AzFirewallPolicy -name "<firewall-policy-name>" -ResourceGroupName "<resource-group-name>"

$firewall.firewallpolicy = $firewallpolicy.id
$firewall.allocate($vnet, $publicip, $publicipmgmt)
echo "Allocating..."
$firewall | set-azfirewall
