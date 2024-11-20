
# vnet defining the spoke 2 network
module "spoke3-vnet" {
  source = "./modules/vnet"

  virtual_network_name          = "${var.company_name}-prod-noeast-vnet"
  resource_group_name           = module.spoke3-resourcegroup.rg_name
  location                      = module.spoke3-resourcegroup.rg_location
  virtual_network_address_space = ["10.53.0.0/16"]
  subnet_names = {
    "az-${var.company_name}-prod-apps-snet" = {
      subnet_name      = "az-${var.company_name}-prod-apps-snet"
      address_prefixes = ["10.53.1.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
  }
}


# first step: create a app-service-plan for Linux, setting the size
resource "azurerm_service_plan" "app-service-plan" {
  name                = "${var.company_name}-prod-app-service-plan"
  location            = module.spoke3-resourcegroup.rg_location
  resource_group_name = module.spoke3-resourcegroup.rg_name
  os_type             = "Linux"
  sku_name            = "B1"
  tags = {
    environment = "Prod"
  }
}

# second step: create the app-service with reference to the juice-shop docker image
resource "azurerm_linux_web_app" "app-service" {
  name                = "${var.company_name}-prod-app-service"
  location            = module.spoke3-resourcegroup.rg_location
  resource_group_name = module.spoke3-resourcegroup.rg_name
  service_plan_id     = azurerm_service_plan.app-service-plan.id
  site_config {
    application_stack {
      docker_image_name = "bkimminich/juice-shop:latest"
    }
  }
  tags = {
    environment = "Prod"
  }
}

# third step: print out the DNS name created
output "app_service_url" {
  value = azurerm_linux_web_app.app-service.default_hostname
}