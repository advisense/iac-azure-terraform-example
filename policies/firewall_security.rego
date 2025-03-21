package terraform.security

deny[msg] {
    # Ensure an Azure Firewall is deployed
    not exists_firewall

    msg = "Azure Firewall must be deployed in the environment"
}

deny[msg] {
    # Ensure Firewall SKU is Standard or Premium
    resource = input.resource_changes[_]
    resource.type == "azurerm_firewall"
    not (resource.change.after.sku == "Standard" or resource.change.after.sku == "Premium")

    msg = "Azure Firewall SKU must be 'Standard' or 'Premium'"
}

deny[msg] {
    # Ensure Firewall has Threat Intelligence Mode set to 'Alert' or 'Deny'
    resource = input.resource_changes[_]
    resource.type == "azurerm_firewall"
    not (resource.change.after.threat_intelligence_mode == "Alert" or resource.change.after.threat_intelligence_mode == "Deny")

    msg = "Azure Firewall Threat Intelligence Mode must be set to 'Alert' or 'Deny'"
}

deny[msg] {
    # Ensure Firewall Logging is enabled
    resource = input.resource_changes[_]
    resource.type == "azurerm_firewall"
    not resource.change.after.diagnostics[0].enabled

    msg = "Azure Firewall logging must be enabled"
}

# Helper function to check if an Azure Firewall exists
exists_firewall {
    some resource
    resource = input.resource_changes[_]
    resource.type == "azurerm_firewall"
}
