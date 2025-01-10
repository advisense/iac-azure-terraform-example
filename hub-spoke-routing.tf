
# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke-internalapp" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.internalapp-vnet, module.azure_firewall_01]
  #depends_on = [module.hub-vnet , module.internalapp-vnet , module.application_gateway, module.vpn_gateway , module.azure_firewall_01]

  virtual_network_peering_name = "prod-vnet-to-az-microsave-internalapp-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.internalapp-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}

# vnet-peering Module is used to create peering between Virtual Networks
module "internalapp-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "microsave-internalapp-vnet-to-az-conn-vnet"
  resource_group_name          = module.internalapp-resourcegroup.rg_name
  virtual_network_name         = module.internalapp-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.internalapp-vnet]
}




# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-workstations" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.workstations-vnet, module.azure_firewall_01]


  virtual_network_peering_name = "microsave-vnet-to-az-workstation-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.workstations-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}


# vnet-peering Module is used to create peering between Virtual Networks
module "workstations-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "microsave-workstation-vnet-to-az-conn-vnet"
  resource_group_name          = module.internal-workstation-resourcegroup.rg_name
  virtual_network_name         = module.workstations-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.workstations-vnet]
}


# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-externalapp-prod" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.externalapp-prod-vnet, module.azure_firewall_01]


  virtual_network_peering_name = "conn-vnet-to-az-externalapp-prod-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.externalapp-prod-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}

module "hub-to-externalapp-test" {
  source     = "./modules/vnet-peering"
  depends_on = [module.hub-vnet, module.externalapp-test-vnet, module.azure_firewall_01]


  virtual_network_peering_name = "conn-vnet-to-az-externalapp-test-vnet"
  resource_group_name          = module.hub-resourcegroup.rg_name
  virtual_network_name         = module.hub-vnet.vnet_name
  remote_virtual_network_id    = module.externalapp-test-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  use_remote_gateways          = "false"

}

# vnet-peering Module is used to create peering between Virtual Networks
module "externalapp-prod-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "microsave-externalapp-prod-vnet-to-az-conn-vnet"
  resource_group_name          = module.externalapp-prod-resourcegroup.rg_name
  virtual_network_name         = module.externalapp-prod-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.externalapp-prod-vnet]
}

module "externalapp-test-to-hub" {
  source = "./modules/vnet-peering"

  virtual_network_peering_name = "microsave-externalapp-test-vnet-to-az-conn-vnet"
  resource_group_name          = module.externalapp-test-resourcegroup.rg_name
  virtual_network_name         = module.externalapp-test-vnet.vnet_name
  remote_virtual_network_id    = module.hub-vnet.vnet_id
  allow_virtual_network_access = "true"
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "false"
  # As there is no gateway while testing - Setting to False
  #use_remote_gateways   = "true"
  use_remote_gateways = "false"
  depends_on          = [module.hub-vnet, module.externalapp-test-vnet]
}


# routetables Module is used to create route tables and associate them with Subnets created by Virtual Networks
module "route_tables" {
  source     = "./modules/routetables"
  depends_on = [module.hub-vnet, module.internalapp-vnet, module.workstations-vnet, module.externalapp-prod-vnet, module.externalapp-test-vnet]

  route_table_name              = "microsave-prod-route"
  location                      = module.hub-resourcegroup.rg_location
  resource_group_name           = module.hub-resourcegroup.rg_name
  bgp_route_propagation_enabled = false

  route_name             = "ToAzureFirewall"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.azure_firewall_01.azure_firewall_private_ip

  subnet_ids = [
    module.internalapp-vnet.vnet_subnet_id[0],
    module.internalapp-vnet.vnet_subnet_id[1],
    module.workstations-vnet.vnet_subnet_id[0],
    module.externalapp-prod-vnet.vnet_subnet_id[0],
    module.externalapp-test-vnet.vnet_subnet_id[0]
  ]

}