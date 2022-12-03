resource "azurerm_bastion_host" "gcc_bastions" {
  for_each            = var.gcc_bastions
  name                = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location            = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  ip_configuration {
    name                 = format("%s%s", each.value["ip_config_name"], random_string.random_suffix_string.result)
    subnet_id            = azurerm_subnet.gcc_subnets[each.value["subnet_key"]].id
    public_ip_address_id = azurerm_public_ip.gcc_public_ips[each.value["public_ip_key"]].id
  }

  depends_on = [
    azurerm_resource_group.gcc_resource_groups,
    azurerm_public_ip.gcc_public_ips,
    azurerm_subnet.gcc_subnets
  ]
}