

# first step: create a app-service-plan for Linux, setting the size
resource "azurerm_service_plan" "app-service-plan" {
  name   = "${var.app_name}-${var.app_environment}-app-service-plan"
  location = azurerm_resource_group.azure-rg.location
  resource_group_name = azurerm_resource_group.azure-rg.name
  os_type = "Linux"
  sku_name = "B1"
  tags = {
    environment = var.app_environment,
    responsible = var.department_id
  }
}

# second step: create the app-service with reference to the juice-shop docker image
resource "azurerm_linux_web_app" "app-service" {
  name = "${var.app_name}-${var.app_environment}-app-service"
  location = azurerm_resource_group.azure-rg.location
  resource_group_name = azurerm_resource_group.azure-rg.name
  service_plan_id = azurerm_service_plan.app-service-plan.id
  site_config {
    application_stack {
        docker_image_name = "bkimminich/juice-shop:latest"
    }
  }
  

  tags = {
    environment = var.app_environment,
    responsible = var.department_id
  }
}

# third step: print out the DNS name created
output "app_service_url" {
  value = azurerm_linux_web_app.app-service.default_hostname
}