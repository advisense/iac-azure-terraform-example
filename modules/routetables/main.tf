resource "azurerm_route_table" "spoke-to-firewall" {
  name                          = var.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled

  route {
    name                   = var.route_name
    address_prefix         = var.address_prefix
    next_hop_type          = var.next_hop_type
    next_hop_in_ip_address = var.next_hop_in_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke-to-firewall" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = azurerm_route_table.spoke-to-firewall.id
}

