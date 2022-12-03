resource "azurerm_public_ip" "gcc_public_ips" {
  for_each            = var.gcc_public_ips
  name                = "${each.value["name"]}${random_string.random_suffix_string.result}"
  location            = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  allocation_method = each.value["allocation_method"]
  sku               = each.value["sku"]

  depends_on = [
    azurerm_resource_group.gcc_resource_groups
  ]
}