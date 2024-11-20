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
  # module.hub-vnet.vnet_subnet_id[2] = AzureFirewallSubnet        - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[3] = GatewaySubnet              - Alphabetical Order
  # module.hub-vnet.vnet_subnet_id[4] = JumpboxSubnet              - Alphabetical Order

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
    "ApplicationGatewaySubnet" = {
      subnet_name      = "ApplicationGatewaySubnet"
      address_prefixes = ["10.50.3.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
    "AzureBastionSubnet" = {
      subnet_name      = "AzureBastionSubnet"
      address_prefixes = ["10.50.4.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
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

  # Used for Application Gateway
  public_ip_name      = "az-conn-prod-noeast-agw-pip02"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# publicip Module is used to create Public IP Address
module "public_ip_03" {
  source = "./modules/publicip"

  # Used for Azure Firewall 
  public_ip_name      = "az-conn-prod-noeast-afw-pip03"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# publicip Module is used to create Public IP Address
module "public_ip_04" {
  source = "./modules/publicip"

  # Used for Azure Bastion
  public_ip_name      = "az-conn-prod-noeast-afw-pip04"
  resource_group_name = module.hub-resourcegroup.rg_name
  location            = module.hub-resourcegroup.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# azurefirewall Module is used to create Azure Firewall 
# Firewall Policy
# Associate Firewall Policy with Azure Firewall
# Network and Application Firewall Rules 
module "azure_firewall_01" {
  source     = "./modules/azurefirewall"
  depends_on = [module.hub-vnet]

  azure_firewall_name = "az-conn-prod-noeast-afw"
  location            = module.hub-resourcegroup.rg_location
  resource_group_name = module.hub-resourcegroup.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ipconfig_name        = "configuration"
  subnet_id            = module.hub-vnet.vnet_subnet_id[2]
  public_ip_address_id = module.public_ip_03.public_ip_address_id

  azure_firewall_policy_coll_group_name = "az-conn-prod-noeast-afw-coll-pol01"
  azure_firewall_policy_name            = "az-conn-prod-noeast-afw-pol01"
  priority                              = 100

  network_rule_coll_name_01     = "Blocked_Network_Rules"
  network_rule_coll_priority_01 = "2000"
  network_rule_coll_action_01   = "Deny"
  network_rules_01 = [
    {
      name                  = "Blocked_rule_1"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["10.8.8.8", "8.10.4.4"]
      destination_ports     = [11]
      protocols             = ["TCP"]
    },
    {
      name                  = "Blocked_rule_2"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["10.8.8.8", "8.10.4.4"]
      destination_ports     = [21]
      protocols             = ["TCP"]
    },
    {
      name                  = "Blocked_rule_3"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["10.8.8.8", "8.10.4.4"]
      destination_ports     = [11]
      protocols             = ["TCP"]
    },
    {
      name                  = "Blocked_rule_4"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["10.8.8.8", "8.10.4.4"]
      destination_ports     = [21]
      protocols             = ["TCP"]
    }
  ]

  network_rule_coll_name_02     = "Allowed_Network_Rules"
  network_rule_coll_priority_02 = "3000"
  network_rule_coll_action_02   = "Allow"
  network_rules_02 = [
    {
      name                  = "Allowed_Network_rule_1"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["172.21.1.10", "8.10.4.4"]
      destination_ports     = [11]
      protocols             = ["TCP"]
    },
    {
      name                  = "Allowed_Network_rule_2"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["172.21.1.10", "8.10.4.4"]
      destination_ports     = [21]
      protocols             = ["TCP"]
    },
    {
      name                  = "Allowed_Network_rule_3"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["172.21.1.10", "8.10.4.4"]
      destination_ports     = [11]
      protocols             = ["TCP"]
    },
    {
      name                  = "Allowed_Network_rule_4"
      source_addresses      = ["10.1.0.0/16"]
      destination_addresses = ["172.21.1.10", "8.10.4.4"]
      destination_ports     = [21]
      protocols             = ["TCP"]
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
      destination_address = module.public_ip_03.public_ip_address
      destination_ports   = ["10"] #3389 if you need RDP
      translated_address  = "10.51.4.4"
      translated_port     = "10" #3389 if you need RDP

      # name                = "nat_rule_collection1_rule1"
      # protocols           = ["TCP", "UDP"]
      # source_addresses    = ["10.0.0.1", "10.0.0.2"]
      # destination_address = "192.168.1.1"
      # destination_ports   = ["80"]
      # translated_address  = "192.168.0.1"
      # translated_port     = "8080"

    },
    # Add more DNAT rules as needed
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
  public_ip_address_id = module.public_ip_04.public_ip_address_id

  depends_on = [module.hub-vnet, module.azure_firewall_01, module.vm-jumpbox-01]
}