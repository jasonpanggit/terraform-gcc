##########################################################################
# This is applicable to H-model and I-model where there is internet zone
# Comment this whole section out if you dont have internet zone
##########################################################################
/*
resource "azurerm_route_table" "aias_internet_azfw_route_table" {
  #for_each            = var.aias_route_tables
  name                = "aias-inter-azfw-route-table${module.aias_model.random_string}"
  location            = module.aias_model.aias_resource_groups["aias_internet_rg"].location
  resource_group_name = module.aias_model.aias_resource_groups["aias_internet_rg"].name

  disable_bgp_route_propagation = true

  #dynamic "route" {
  #for_each = lookup(each.value, "routes", null)
  #content {
  #name                   = lookup(route.value, "name", null)
  #address_prefix         = lookup(route.value, "address_prefix", null)
  #next_hop_type          = lookup(route.value, "next_hop_type", null)
  #next_hop_in_ip_address = route.value["next_hop_in_ip_address"] == "firewall" ? module.aias_model.aias_firewalls[route.value["key"]].ip_configuration[0].private_ip_address : route.value["next_hop_in_ip_address"]
  #}
  #}
  #tags = each.value["tags"]

  route {
    name                   = "Route-to-Firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.aias_model.aias_firewalls["aias_internet_azfw"].ip_configuration[0].private_ip_address
  }
  depends_on = [
    module.aias_model.aias_resource_groups
  ]
}

resource "azurerm_route_table" "aias_internet_app_route_table" {
  name                          = "aias-inter-app-route-table${module.aias_model.random_string}"
  location                      = module.aias_model.aias_resource_groups["aias_internet_rg"].location
  resource_group_name           = module.aias_model.aias_resource_groups["aias_internet_rg"].name
  disable_bgp_route_propagation = true
  route {
    name                   = "Route-to-Proxy"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.aias_model.aias_linux_vms["aias_internet_gut_proxy_vm"].private_ip_address
  }
  depends_on = [
    module.aias_model.aias_resource_groups
  ]
}

resource "azurerm_subnet_route_table_association" "aias_internet_app_route_table_association" {
  route_table_id = azurerm_route_table.aias_internet_app_route_table.id
  subnet_id      = module.aias_model.aias_subnets["aias_internet_app_subnet"].id

  depends_on = [
    azurerm_route_table.aias_internet_app_route_table,
    module.aias_model.aias_subnets
  ]
}
*/