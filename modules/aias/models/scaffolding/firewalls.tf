resource "azurerm_firewall" "aias_firewalls" {
  for_each            = var.aias_firewalls
  name                = "${each.value["name"]}${random_string.random_suffix_string.result}"
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  sku_name = each.value["sku_name"]
  sku_tier = each.value["sku_tier"]

  ip_configuration {
    name                 = "${each.value["ip_config_name"]}${random_string.random_suffix_string.result}"
    subnet_id            = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
    public_ip_address_id = azurerm_public_ip.aias_public_ips[each.value["public_ip_key"]].id
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_public_ip.aias_public_ips
  ]
}