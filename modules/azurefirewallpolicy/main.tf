resource "azurerm_firewall_policy" "az-firewall-pol01" {
  name                = var.azure_firewall_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

 