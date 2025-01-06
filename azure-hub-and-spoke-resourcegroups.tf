# The HUB: is the central point of connectivity for cross-premises networks.
# should contain a bastion, a firewall, 
# and optionally a VPN gateway and a application gateway
module "hub-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-conn-prod-noeast-net-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "Hub"
    Role            = "Network"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

# SPOKE 1 is the company's Application SPOKE for the internal application
module "spoke1-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-prod-noeast-spoke1-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "BizApp"
    Role            = "InternalApp"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

# SPOKE 2 is the company's SPOKE for Virtual Workstations
module "spoke2-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-prod-noeast-spoke2-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "BizApp"
    Role            = "Workstations"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

# SPOKE 3 is the company's SPOKE for Internetfacing applications
module "spoke3-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-prod-noeast-spoke3-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "WebApps"
    Role            = "CustomerApps"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

# SPOKE 4 is the company's SPOKE for Internetfacing applications TEST
module "spoke4-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-prod-noeast-spoke4-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "WebApps"
    Role            = "CustomerApps"
    Environment     = "Test"
    CompanyName     = "${var.company_name}"
  }
}

# SPOKE 5 is for the Container Registry
module "containerreg-resourcegroup" {
  source         = "./modules/resourcegroups"
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-containerreg-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "Management"
    Role            = "ContainerRegistry"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

# This spoke is the central management spoke contain a jumpserver
module "mgmt-resourcegroup" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-mgmt-prod-noeast-bkp-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "Management"
    Role            = "Central management"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

# Resource Group Module is Used to Create Resource Groups
module "mgmt-resourcegroup_01" {
  source = "./modules/resourcegroups"
  # Resource Group Variables
  az_rg_name     = "${var.unique_prefix}-${var.company_name}-mgmt-prod-noeast-rg"
  az_rg_location = var.rg_location
  az_tags = {
    ApplicationName = "Management"
    Role            = "Central management"
    Environment     = "Prod"
    CompanyName     = "${var.company_name}"
  }
}

