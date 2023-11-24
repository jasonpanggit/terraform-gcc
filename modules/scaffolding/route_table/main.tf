# Route tables
resource "azurerm_route_table" "route_tables" {
  for_each            = var.route_tables
  name                = format("%s_%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  dynamic "route" {
    for_each = lookup(each.value, "routes", null)
    content {
      name           = lookup(route.value, "name", null)
      address_prefix = lookup(route.value, "address_prefix", null)
      next_hop_type  = lookup(route.value, "next_hop_type", null)
      # next_hop_resource type is either firewall or linux_vm
      next_hop_in_ip_address = route.value.next_hop_resource_type == "firewall" ? var.firewalls[route.value.next_hop_resource_key].ip_configuration[0].private_ip_address : var.linux_vms[route.value.next_hop_resource_key].private_ip_address
    }
  }
  tags = each.value.tags
}

# Route table associations
resource "azurerm_subnet_route_table_association" "route_table_associations" {
  for_each       = var.route_tables_associations
  route_table_id = azurerm_route_table.route_tables[each.value.route_table_key].id
  subnet_id      = var.subnets[each.value.subnet_key].id

  depends_on = [
    azurerm_route_table.route_tables
  ]
}