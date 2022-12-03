resource "azurerm_private_dns_zone" "gcc_private_dns_zones" {
  for_each            = var.gcc_private_dns_zones
  name                = each.value["name"]
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  depends_on = [
    azurerm_resource_group.gcc_resource_groups
  ]
}

resource "azurerm_private_dns_a_record" "gcc_private_dns_zone_apim_a_records" {
  for_each            = var.gcc_private_dns_zone_apim_a_records
  name                = "${azurerm_api_management.gcc_apims[each.value["apim_key"]].name}${each.value["endpoint_name"]}"
  zone_name           = azurerm_private_dns_zone.gcc_private_dns_zones[each.value["private_dns_zone_key"]].name
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  ttl     = each.value["ttl"]
  records = [azurerm_api_management.gcc_apims[each.value["apim_key"]].private_ip_addresses[0]]

  depends_on = [
    azurerm_resource_group.gcc_resource_groups,
    azurerm_api_management.gcc_apims,
    azurerm_private_dns_zone.gcc_private_dns_zones
  ]
}