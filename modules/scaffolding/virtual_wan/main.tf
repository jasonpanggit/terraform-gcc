# vWAN
resource "azurerm_virtual_wan" "vwans" {
  for_each            = var.vwans
  name                = format("%s_%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
}

# vWAN Hubs
resource "azurerm_virtual_hub" "vwan_hubs" {
  for_each            = var.vwan_hubs
  name                = format("%s_%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  virtual_wan_id      = azurerm_virtual_wan.vwans[each.value.vwan_key].id
  address_prefix      = each.value.address_prefix

  # dynamic "route" {
  #   for_each = each.value.routes
  #   content {
  #     address_prefixes    = route.value.address_prefixes
  #     next_hop_ip_address = route.value.next_hop_resource_type == "firewall" ? var.firewalls[route.value.next_hop_resource_key].id : var.linux_vms[route.value.next_hop_resource_key].id
  #   }
  # }
}

# vWAN Hub Connections
resource "azurerm_virtual_hub_connection" "vwan_hub_connections" {
  for_each                  = var.vwan_hub_connections
  name                      = format("%s_%s", each.value.name, var.random_string)
  virtual_hub_id            = azurerm_virtual_hub.vwan_hubs[each.value.vwan_hub_key].id
  remote_virtual_network_id = var.virtual_networks[each.value.vnet_key].id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = each.value.routings
    content {
      associated_route_table_id = azurerm_virtual_hub_route_table.vwan_hub_route_tables[routing.value.associated_route_table_key].id
      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_tables
        content {
          labels = lookup(propagated_route_table.value, "labels", null)
          # TODO: how to dynamic generate a list of route table ids for propagation
          route_table_ids = [azurerm_virtual_hub_route_table.vwan_hub_route_tables[propagated_route_table.value.propagated_route_table_key].id]
        }
      }
      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_routes
        content {
          name                = static_vnet_route.value.name
          address_prefixes    = static_vnet_route.value.address_prefixes
          next_hop_ip_address = static_vnet_route.value.next_hop_resource_type == "firewall" ? var.firewalls[static_vnet_route.value.next_hop_resource_key].ip_configuration[0].private_ip_address : var.linux_vms[static_vnet_route.value.next_hop_resource_key].private_ip_address
        }
      }
    }
  }
}

# vWAN Hub Route Tables
resource "azurerm_virtual_hub_route_table" "vwan_hub_route_tables" {
  for_each       = var.vwan_hub_route_tables
  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.vwan_hubs[each.value.vwan_hub_key].id
  labels         = lookup(each.value, "labels", null)

  # dynamic "route" {
  #   for_each = each.value.routes
  #   content {
  #     name              = route.value.name
  #     destinations_type = route.value.destinations_type
  #     destinations      = route.value.destinations
  #     next_hop_type     = route.value.next_hop_type
  #     next_hop          = azurerm_virtual_hub_connection.vwan_hub_connections[route.value.vwan_hub_connection_key].id
  #   }
  # }
}

# vWAN Hub Route Table Routes
resource "azurerm_virtual_hub_route_table_route" "vwan_hub_route_table_routes" {
  for_each          = var.vwan_hub_route_table_routes
  route_table_id    = azurerm_virtual_hub_route_table.vwan_hub_route_tables[each.value.vwan_hub_route_table_key].id
  name              = each.value.name
  destinations_type = each.value.destinations_type
  destinations      = each.value.destinations
  next_hop_type     = each.value.next_hop_type
  next_hop          = azurerm_virtual_hub_connection.vwan_hub_connections[each.value.vwan_hub_connection_key].id
}