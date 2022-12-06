resource "azurerm_private_dns_zone" "private_dns_zones" {
  for_each            = var.private_dns_zones
  name                = each.value["name"]
  resource_group_name = var.resource_groups[each.value["rg_key"]].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_links" {
  for_each              = var.private_dns_zone_vnet_links
  name                  = format("%s%s", each.value["name"], var.random_string)
  resource_group_name   = var.resource_groups[each.value["rg_key"]].name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zones[each.value["private_dns_zone_key"]].name
  virtual_network_id    = var.virtual_networks[each.value["vnet_key"]].id
}