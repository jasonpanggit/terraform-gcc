# Bastion public IPs
resource "azurerm_public_ip" "bastion_public_ips" {
  for_each            = var.bastion_public_ips
  name                = format("%s%s", each.value["name"], var.random_string)
  location            = var.resource_groups[each.value["rg_key"]].location
  resource_group_name = var.resource_groups[each.value["rg_key"]].name

  allocation_method = each.value["allocation_method"]
  sku               = each.value["sku"]
}

# Bastions
resource "azurerm_bastion_host" "bastions" {
  for_each            = var.bastions
  name                = format("%s%s", each.value["name"], var.random_string)
  location            = var.resource_groups[each.value["rg_key"]].location
  resource_group_name = var.resource_groups[each.value["rg_key"]].name

  ip_configuration {
    name                 = format("%s%s", each.value["ip_config_name"], var.random_string)
    subnet_id            = var.subnets[each.value["subnet_key"]].id
    public_ip_address_id = azurerm_public_ip.bastion_public_ips[each.value["public_ip_key"]].id
  }

  depends_on = [
    azurerm_public_ip.bastion_public_ips
  ]
}