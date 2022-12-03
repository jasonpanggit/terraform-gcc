resource "azurerm_route_table" "gcc_route_tables" {
  for_each            = var.gcc_route_tables
  name                = "${each.value["name"]}${random_string.random_suffix_string.result}"
  location             = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name  = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  disable_bgp_route_propagation = each.value["disable_bgp_route_propagation"]

  dynamic "route" {
  for_each = lookup(each.value, "routes", null)
  content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      # next_hop_resource type is either firewall or linux_vm
      next_hop_in_ip_address = route.value["next_hop_resource_type"] == "firewall" ? azurerm_firewall.gcc_firewalls[route.value["next_hop_resource_key"]].ip_configuration[0].private_ip_address : azurerm_linux_virtual_machine.gcc_linux_proxy_vms[route.value["next_hop_resource_key"]].private_ip_address
    }
  }
  tags = each.value["tags"]

  depends_on = [
    azurerm_resource_group.gcc_resource_groups,
    azurerm_firewall.gcc_firewalls,
    azurerm_linux_virtual_machine.gcc_linux_proxy_vms
  ]
}

resource "azurerm_subnet_route_table_association" "gcc_route_table_associations" {
  for_each            = var.gcc_route_tables
  route_table_id = azurerm_route_table.gcc_route_tables[each.value["rt_key"]].id
  subnet_id      = azurerm_subnet.gcc_subnets[each.value["subnet_key"]].id

  depends_on = [
    azurerm_route_table.gcc_route_tables,
    azurerm_subnet.gcc_subnets
  ]
}