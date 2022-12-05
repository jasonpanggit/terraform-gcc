# Firewall public IPs
resource "azurerm_public_ip" "gcc_firewall_public_ips" {
  for_each            = var.gcc_firewall_public_ips
  name                = format("%s%s", each.value["name"], var.random_string)
  location            = var.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name = var.gcc_resource_groups[each.value["rg_key"]].name

  allocation_method = each.value["allocation_method"]
  sku               = each.value["sku"]
}

# Firewalls
resource "azurerm_firewall" "gcc_firewalls" {
  for_each            = var.gcc_firewalls
  name                = format("%s%s", each.value["name"], var.random_string)
  location            = var.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name = var.gcc_resource_groups[each.value["rg_key"]].name

  sku_name    = each.value["sku_name"]
  sku_tier    = each.value["sku_tier"]
  dns_servers = each.value["dns_servers"]
  ip_configuration {
    name                 = format("%s%s", each.value["ip_config_name"], var.random_string)
    subnet_id            = var.gcc_subnets[each.value["subnet_key"]].id
    public_ip_address_id = azurerm_public_ip.gcc_firewall_public_ips[each.value["public_ip_key"]].id
  }

  depends_on = [
    azurerm_public_ip.gcc_firewall_public_ips
  ]
}