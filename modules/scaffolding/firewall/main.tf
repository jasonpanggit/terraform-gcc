# Firewall public IPs
resource "azurerm_public_ip" "firewall_public_ips" {
  for_each            = var.firewall_public_ips
  name                = format("%s%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  allocation_method = each.value.allocation_method
  sku               = each.value.sku
}

# Firewalls
resource "azurerm_firewall" "firewalls" {
  for_each            = var.firewalls
  name                = format("%s%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  sku_name    = each.value.sku_name
  sku_tier    = each.value.sku_tier
  dns_servers = each.value.dns_servers
  ip_configuration {
    name                 = format("%s%s", each.value.ip_config_name, var.random_string)
    subnet_id            = var.subnets[each.value.subnet_key].id
    public_ip_address_id = azurerm_public_ip.firewall_public_ips[each.value.public_ip_key].id
  }

  dynamic "virtual_hub" {
    for_each = each.value.virtual_hubs
    content {
      virtual_hub_id = var.vwan_hubs[virtual_hub.value.vwan_hub_key].id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  } 

  depends_on = [
    azurerm_public_ip.firewall_public_ips
  ]
}

resource "azurerm_firewall_application_rule_collection" "firewall_app_rules" {
  for_each            = var.firewall_app_rules
  name                = each.value.name
  azure_firewall_name = azurerm_firewall.firewalls[each.value.firewall_key].name
  resource_group_name = var.resource_groups[each.value.rg_key].name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns
      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }
  }
}