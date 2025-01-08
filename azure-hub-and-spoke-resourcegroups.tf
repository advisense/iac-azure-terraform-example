# The HUB: is the central point of connectivity for cross-premises networks.
# should contain a bastion, a firewall, 
# and optionally a VPN gateway and a application gateway
module "hub-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "microsave-hub-resourcegroup"
  az_rg_location = var.rg_location
  az_tags = {
    Role        = "Hub"
    Environment = "Prod"
  }
}

# SPOKE 1 is the company's Application SPOKE for the internal application
module "internalapp-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "microsave-internapp-resourcegroup"
  az_rg_location = var.rg_location
  az_tags = {
    Role        = "InternalApp"
    Environment = "Prod"
  }
}

# SPOKE 2 is the company's SPOKE for Virtual Workstations
module "internal-workstation-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "microsave-workstations-resourcegroup"
  az_rg_location = var.rg_location
  az_tags = {
    Role        = "Workstations"
    Environment = "Prod"
  }
}

# SPOKE 3 is the company's SPOKE for Internetfacing applications
module "externalapp-prod-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "microsave-externalapp-prod-resourcegroup"
  az_rg_location = var.rg_location
  az_tags = {
    Role        = "ExternalApp"
    Environment = "Prod"
  }
}

# SPOKE 4 is the company's SPOKE for Internetfacing applications TEST
module "externalapp-test-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "microsave-externalapp-test-resourcegroup"
  az_rg_location = var.rg_location
  az_tags = {
    Role        = "CustomerApps"
    Environment = "Test"
  }
}





