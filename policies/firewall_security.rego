package terraform.analysis

firewall_exists {
    input.resource_changes[_].type == "azurerm_firewall"
}

deny[msg] {
    not firewall_exists
    msg = "No firewall resouce found"
}

