# API managements
resource "azurerm_api_management" "gcc_internal_apims" {
  for_each             = var.gcc_internal_apims
  name                 = format("%s%s", each.value["name"], var.random_string)
  location             = var.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name  = var.gcc_resource_groups[each.value["rg_key"]].name
  publisher_name       = each.value["publisher_name"]
  publisher_email      = each.value["publisher_email"]
  sku_name             = "${each.value["sku_name"]}_${each.value["sku_capacity"]}"
  virtual_network_type = each.value["type"]

  virtual_network_configuration {
    subnet_id = var.gcc_subnets[each.value["subnet_key"]].id
  }
}