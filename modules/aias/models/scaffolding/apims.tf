resource "azurerm_api_management" "aias_apims" {
  for_each             = var.aias_apims
  name                 = "${each.value["name"]}${random_string.random_suffix_string.result}"
  location             = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name  = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name
  publisher_name       = each.value["publisher_name"]
  publisher_email      = each.value["publisher_email"]
  sku_name             = "${each.value["sku_name"]}_${each.value["sku_capacity"]}"
  virtual_network_type = each.value["type"]

  virtual_network_configuration {
    subnet_id = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_subnet.aias_subnets
  ]
}