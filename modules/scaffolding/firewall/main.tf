# Firewall public IPs
resource "azurerm_public_ip" "firewall_public_ips" {
  for_each            = var.firewall_public_ips
  name                = format("%s_%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  allocation_method = each.value.allocation_method
  sku               = each.value.sku
}

# Firewalls
resource "azurerm_firewall" "firewalls" {
  for_each            = var.firewalls
  name                = format("%s_%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  sku_name = each.value.sku_name
  sku_tier = each.value.sku_tier

  #dns_servers = each.value.dns_servers
  #dns_servers = each.value.dns_server_type == "firewall" ? azurerm_firewall.firewalls[each.value.dns_server_key].ip_configuration[0].private_ip_address : (each.value.dns_server_type == "private_dns_resolver" ? var.private_dns_resolver_inbound_endpoints[each.value.dns_server_key].ip_configurations[0].priavte_ip_address : each.value.dns_server_ip)

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations
    content {
      name                 = format("%s_%s", ip_configuration.value.ip_config_name, var.random_string)
      subnet_id            = var.subnets[ip_configuration.value.subnet_key].id
      public_ip_address_id = azurerm_public_ip.firewall_public_ips[ip_configuration.value.public_ip_key].id
    }
  }

  dynamic "virtual_hub" {
    for_each = each.value.virtual_hubs
    content {
      virtual_hub_id  = var.vwan_hubs[virtual_hub.value.vwan_hub_key].id
      public_ip_count = virtual_hub.value.public_ip_count
    }
  }

  depends_on = [
    azurerm_public_ip.firewall_public_ips
  ]
}

resource "azurerm_firewall_application_rule_collection" "firewall_app_rule_collections" {
  for_each            = var.firewall_app_rule_collections
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
      fqdn_tags        = lookup(rule.value, "fqdn_tags", null)
      target_fqdns     = lookup(rule.value, "target_fqdns", null)

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

resource "azurerm_firewall_network_rule_collection" "firewall_network_rule_collections" {
  for_each            = var.firewall_network_rule_collections
  name                = each.value.name
  azure_firewall_name = azurerm_firewall.firewalls[each.value.firewall_key].name
  resource_group_name = var.resource_groups[each.value.rg_key].name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}