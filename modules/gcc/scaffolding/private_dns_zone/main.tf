resource "azurerm_private_dns_zone" "gcc_private_dns_zones" {
  for_each            = var.gcc_private_dns_zones
  name                = each.value["name"]
  resource_group_name = var.gcc_resource_groups[each.value["rg_key"]].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "gcc_private_dns_zone_vnet_links" {
  for_each              = var.gcc_private_dns_zone_vnet_links
  name                  = format("%s%s", each.value["name"], var.random_string)
  resource_group_name   = var.gcc_resource_groups[each.value["rg_key"]].name
  private_dns_zone_name = azurerm_private_dns_zone.gcc_private_dns_zones[each.value["private_dns_zone_key"]].name
  virtual_network_id    = var.gcc_virtual_networks[each.value["vnet_key"]].id
}

resource "azurerm_private_dns_a_record" "gcc_private_dns_zone_apim_a_records" {
  for_each            = var.gcc_private_dns_zone_apim_a_records
  name                = "${var.gcc_internal_apims[each.value["apim_key"]].name}${each.value["endpoint_name"]}"
  zone_name           = azurerm_private_dns_zone.gcc_private_dns_zones[each.value["private_dns_zone_key"]].name
  resource_group_name = var.gcc_resource_groups[each.value["rg_key"]].name

  ttl     = each.value["ttl"]
  records = [var.gcc_internal_apims[each.value["apim_key"]].private_ip_addresses[0]]
}