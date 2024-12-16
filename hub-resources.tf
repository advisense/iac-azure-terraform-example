# vnet Module is used to create Virtual Networks and Subnets
module "hub-vnet" {
  source = "./modules/vnet"

  virtual_network_name          = "az-conn-prod-noeast-vnet"
  resource_group_name           = module.hub-resourcegroup.rg_name
  location                      = module.hub-resourcegroup.rg_location
  virtual_network_address_space = ["10.50.0.0/16"]
  # Subnets are used in Index for other modules to refer
  # module.hub-vnet.vnet_subnet_id[0] = ApplicationGatewaySubnet   - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[1] = AzureBastionSubnet         - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[2] = AzureFirewallManagementSubnet        - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[3] = AzureFirewallSubnet        - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[4] = GatewaySubnet              - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[5] = JumpboxSubnet              - Alphabetical Order

  subnet_names = {
    "GatewaySubnet" = {
      subnet_name      = "GatewaySubnet"
      address_prefixes = ["10.50.1.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    },
    "AzureFirewallSubnet" = {
      subnet_name      = "AzureFirewallSubnet"
      address_prefixes = ["10.50.2.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    },
    "AzureFirewallManagementSubnet" = {
      subnet_name      = "AzureFirewallManagementSubnet"
      address_prefixes = ["10.50.6.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    },
    "ApplicationGatewaySubnet" = {
      subnet_name      = "ApplicationGatewaySubnet"
      address_prefixes = ["10.50.3.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    },
    "AzureBastionSubnet" = {
      subnet_name      = "AzureBastionSubnet"
      address_prefixes = ["10.50.4.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    },
    "JumpboxSubnet" = {
      subnet_name      = "JumpboxSubnet"
      address_prefixes = ["10.50.5.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
  }
}

# publicip Module is used to create Public IP Address
module "public_ip_01" {
  source = "./modules/publicip"

  # Used for VPN Gateway 
  public_ip_name      = "az-conn-prod-noeast-vgw-pip01"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}


# publicip Module is used to create Public IP Address
module "public_ip_02" {
  source = "./modules/publicip"

  # Used for Azure Firewall 
  public_ip_name      = "az-conn-prod-noeast-afw-pip02"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# publicip Module is used to create Public IP Address
module "public_ip_03" {
  source = "./modules/publicip"

  # Used for Azure Bastion
  public_ip_name      = "az-conn-prod-noeast-bastion-pip03"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}
module "public_ip_04" {
  source = "./modules/publicip"

  # Used for Azure Bastion
  public_ip_name      = "az-conn-prod-noeast-afwmgmt-pip04"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}


module "azure_firewall_policy_01" {
  source = "./modules/azurefirewallpolicy"
  depends_on = [module.hub-vnet]

  azure_firewall_policy_name = "az-conn-prod-noeast-afw-pol01"
  location = module.hub-resourcegroup.rg_location
  resource_group_name = module.hub-resourcegroup.rg_name
  sku = "Basic"
}
# azurefirewall Module is used to create Azure Firewall 
# Firewall Policy
# Associate Firewall Policy with Azure Firewall
# Network and Application Firewall Rules 
module "azure_firewall_01" {
  source     = "./modules/azurefirewall"
  depends_on = [module.hub-vnet, module.azure_firewall_policy_01, module.azure_firewall_rule_coll_group]

  azure_firewall_name = "az-conn-prod-noeast-afw"
  location            = module.hub-resourcegroup.rg_location
  resource_group_name = module.hub-resourcegroup.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  firewall_policy_id = module.azure_firewall_policy_01.id

  ipconfig_name        = "configuration"
  subnet_id            = module.hub-vnet.vnet_subnet_id[3]
  public_ip_address_id = module.public_ip_02.public_ip_address_id

  ipconfig_name_mgmt        = "management"
  subnet_id_mgmt            = module.hub-vnet.vnet_subnet_id[2]
  public_ip_address_id_mgmt = module.public_ip_04.public_ip_address_id
}




module "azure_firewall_rule_coll_group" {
  source = "./modules/azurefirewallrulecolgrp"
  depends_on = [module.hub-vnet, module.azure_firewall_policy_01]

  azure_firewall_policy_coll_group_name = "az-conn-prod-noeast-afw-coll-pol01"
  firewall_policy_id = module.azure_firewall_policy_01.id
  priority = 150

  network_rule_coll_name_01     = "Blocked_Network_Rules"
  network_rule_coll_priority_01 = "2000"
  network_rule_coll_action_01   = "Deny"
  network_rules_01 = [
   
  ]

  network_rule_coll_name_02     = "Allowed_Network_Rules"
  network_rule_coll_priority_02 = "3000"
  network_rule_coll_action_02   = "Allow"
  network_rules_02 = [
    {
      name                  = "Spoke1toSpoke2"
      source_addresses      = ["10.51.0.0/16"]
      destination_addresses = ["10.52.0.0/16"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "Spoke2toSpoke1"
      source_addresses      = ["10.52.0.0/16"]
      destination_addresses = ["10.51.0.0/16"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "Spoke1toSpoke3"
      source_addresses      = ["10.51.0.0/16"]
      destination_addresses = ["10.53.0.0/16"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "Spoke2toSpoke3"
      source_addresses      = ["10.52.0.0/16"]
      destination_addresses = ["10.53.0.0/16"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "Spoke3toSpoke1"
      source_addresses      = ["10.53.0.0/16"]
      destination_addresses = ["10.51.0.0/16"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    },
    {
      name                  = "Spoke3toSpoke2"
      source_addresses      = ["10.53.0.0/16"]
      destination_addresses = ["10.52.0.0/16"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    }
  ]


  application_rule_coll_name     = "Allowed_websites"
  application_rule_coll_priority = "4000"
  application_rule_coll_action   = "Allow"
  application_rules = [
    {
      name              = "Allowed_website_01"
      source_addresses  = ["*"]
      destination_fqdns = ["whatismyipaddress.com"]
    },
    {
      name              = "Allowed_website_02"
      source_addresses  = ["*"]
      destination_fqdns = ["*.google.com"]
    },
    {
      name              = "Allowed_website_03"
      source_addresses  = ["*"]
      destination_fqdns = ["*.advisense.com"]
    }
  ]
  application_protocols = [
    {
      type = "Http"
      port = 80
    },
    {
      type = "Https"
      port = 443
    }
  ]
  dnat_rule_coll_name     = "DNATCollection"
  dnat_rule_coll_priority = "1000"
  dnat_rule_coll_action   = "Dnat"
  dnat_rules = [
    {
      name                = "DNATRuleRDP"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = module.public_ip_02.public_ip_address
      destination_ports   = ["3389"] #3389 if you need RDP
      translated_address  = "10.51.1.4"
      translated_port     = "3389" #3389 if you need RDP

    }
  ]

}

# bastion Module is used to create Bastion in Hub Virtual Network - To Console into Virtual Machines Securely
module "vm-bastion" {
  source = "./modules/bastion"

  bastion_host_name   = "az-conn-prod-noeast-jmp-bastion"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location

  ipconfig_name        = "configuration"
  subnet_id            = module.hub-vnet.vnet_subnet_id[1]
  public_ip_address_id = module.public_ip_03.public_ip_address_id

  depends_on = [module.hub-vnet, module.azure_firewall_01, module.vm-jumpbox-01]
}