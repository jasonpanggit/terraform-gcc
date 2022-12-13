# API managements
resource "azurerm_api_management" "internal_apims" {
  for_each             = var.internal_apims
  name                 = format("%s%s", each.value.name, var.random_string)
  location             = var.resource_groups[each.value.rg_key].location
  resource_group_name  = var.resource_groups[each.value.rg_key].name
  publisher_name       = each.value.publisher_name
  publisher_email      = each.value.publisher_email
  sku_name             = "${each.value.sku_name}_${each.value.sku_capacity}"
  virtual_network_type = each.value.type

  virtual_network_configuration {
    subnet_id = var.subnets[each.value.subnet_key].id
  }
}

resource "azurerm_private_dns_a_record" "internal_apims_private_dns_zone_a_records" {
  for_each            = var.internal_apims_private_dns_zone_a_records
  name                = "${azurerm_api_management.internal_apims[each.value.apim_key].name}${each.value.endpoint_name}"
  zone_name           = var.private_dns_zones[each.value.private_dns_zone_key].name
  resource_group_name = var.resource_groups[each.value.rg_key].name

  ttl     = each.value.ttl
  records = [
    azurerm_api_management.internal_apims[each.value.apim_key].private_ip_addresses[0]
  ]
}