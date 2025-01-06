
# vnet defining the spoke 2 network
module "spoke4-vnet" {
  source = "./modules/vnet"

  virtual_network_name          = "${var.company_name}-test-noeast-vnet-spoke3"
  resource_group_name           = module.spoke4-resourcegroup.rg_name
  location                      = module.spoke4-resourcegroup.rg_location
  virtual_network_address_space = ["10.54.0.0/16"]
  subnet_names = {
    "az-${var.company_name}-test-apps-snet" = {
      subnet_name      = "az-${var.company_name}-test-apps-snet"
      address_prefixes = ["10.54.1.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
  }
}


# first step: create a app-service-plan for Linux, setting the size
resource "azurerm_service_plan" "app-service-plan-test" {
  name                = "${var.company_name}-test-app-service-plan"
  location            = module.spoke4-resourcegroup.rg_location
  resource_group_name = module.spoke4-resourcegroup.rg_name
  os_type             = "Linux"
  sku_name            = "B1"
  tags = {
    environment = "Test"
  }
}

# second step: create the app-service with reference to the juice-shop docker image
resource "azurerm_linux_web_app" "app-service-test" {
  name                = "${var.company_name}-test-app-service"
  location            = module.spoke4-resourcegroup.rg_location
  resource_group_name = module.spoke4-resourcegroup.rg_name
  service_plan_id     = azurerm_service_plan.app-service-plan.id

  site_config {
    application_stack {
      docker_image_name   = var.container_image
      docker_registry_url = var.container_docker_registry_url

    }
  }

  tags = {
    environment = "Test"
  }

}

# third step: print out the DNS name created
output "app_service_url_test" {
  value = azurerm_linux_web_app.app-service.default_hostname
}