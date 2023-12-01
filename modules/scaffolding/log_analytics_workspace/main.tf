resource "azurerm_log_analytics_workspace" "log_analytics_workspaces" {
  for_each            = var.log_analytics_workspaces
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days
}