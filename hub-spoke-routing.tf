
# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke1" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.spoke1-vnet, module.azure_firewall_01]
  #depends_on = [module.hub-vnet , module.spoke1-vnet , module.application_gateway, module.vpn_gateway , module.azure_firewall_01]

  virtual_network_peering_name = "az-conn-prod-noeast-vnet-to-az-${var.company_name}-spoke1-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.spoke1-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}

# vnet-peering Module is used to create peering between Virtual Networks
module "spoke1-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "az-${var.company_name}-spoke1-vnet-to-az-conn-prod-noeast-vnet"
  resource_group_name          = module.spoke1-resourcegroup.rg_name
  virtual_network_name         = module.spoke1-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.spoke1-vnet]
}




# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke2" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.spoke2-vnet, module.azure_firewall_01]


  virtual_network_peering_name = "az-conn-prod-noeast-vnet-to-az-${var.company_name}-spoke2-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.spoke2-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}


# vnet-peering Module is used to create peering between Virtual Networks
module "spoke2-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "az-${var.company_name}-spoke2-vnet-to-az-conn-prod-noeast-vnet"
  resource_group_name          = module.spoke2-resourcegroup.rg_name
  virtual_network_name         = module.spoke2-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.spoke2-vnet]
}


# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke3" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.spoke3-vnet, module.azure_firewall_01]


  virtual_network_peering_name = "az-conn-prod-noeast-vnet-to-az-${var.company_name}-spoke3-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.spoke3-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}


# vnet-peering Module is used to create peering between Virtual Networks
module "spoke3-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "az-${var.company_name}-spoke3-vnet-to-az-conn-prod-noeast-vnet"
  resource_group_name          = module.spoke3-resourcegroup.rg_name
  virtual_network_name         = module.spoke3-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.spoke3-vnet]
}



# routetables Module is used to create route tables and associate them with Subnets created by Virtual Networks
module "route_tables" {
  source     = "./modules/routetables"
  depends_on = [module.hub-vnet, module.spoke1-vnet, module.spoke2-vnet, module.spoke3-vnet]

  route_table_name              = "az-${var.company_name}-prod-noeast-route"
  location                      = module.hub-resourcegroup.rg_location
  resource_group_name           = module.hub-resourcegroup.rg_name
  bgp_route_propagation_enabled = false

  route_name             = "ToAzureFirewall"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.azure_firewall_01.azure_firewall_private_ip

  subnet_ids = [
    module.spoke1-vnet.vnet_subnet_id[0],
    module.spoke1-vnet.vnet_subnet_id[1],
    module.spoke2-vnet.vnet_subnet_id[0],
    module.spoke3-vnet.vnet_subnet_id[0]
  ]

}