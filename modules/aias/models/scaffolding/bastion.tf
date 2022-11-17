resource "azurerm_bastion_host" "aias_bastions" {
  for_each            = var.aias_bastions
  name                = "${each.value["name"]}${var.random_string}"
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  ip_configuration {
    name                 = "${each.value["ip_config_name"]}${var.random_string}"
    subnet_id            = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
    public_ip_address_id = azurerm_public_ip.aias_public_ips[each.value["public_ip_key"]].id
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_public_ip.aias_public_ips,
    azurerm_subnet.aias_subnets
  ]
}