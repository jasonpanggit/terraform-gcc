resource "azurerm_app_service_environment_v3" "app_service_environments_v3" {
  for_each            = var.app_service_environments_v3
  name                = format("%s%s", each.value["name"], var.random_string)
  resource_group_name = var.resource_groups[each.value["rg_key"]].name
  subnet_id           = var.subnets[each.value["subnet_key"]].id

  internal_load_balancing_mode = each.value["internal_load_balancing_mode"]

  dynamic "cluster_setting" {
    for_each = each.value["cluster_settings"]
    content {
      name  = cluster_setting.value["name"]
      value = cluster_setting.value["value"]
    }
  }
}

resource "azurerm_service_plan" "app_service_plans" {
  for_each                   = var.app_service_plans
  name                       = format("%s%s", each.value["name"], var.random_string)
  location                   = var.resource_groups[each.value["rg_key"]].location
  resource_group_name        = var.resource_groups[each.value["rg_key"]].name
  os_type                    = each.value["os_type"]
  sku_name                   = each.value["sku_name"]
  app_service_environment_id = azurerm_app_service_environment_v3.app_service_environments_v3[each.value["asev3_key"]].id

  depends_on = [
    azurerm_app_service_environment_v3.app_service_environments_v3
  ]
}