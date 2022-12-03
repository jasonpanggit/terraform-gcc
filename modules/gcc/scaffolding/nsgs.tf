resource "azurerm_network_security_group" "gcc_nsgs" {
  for_each            = var.gcc_network_security_groups
  name                = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location            = var.location
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  dynamic "security_rule" {
    for_each = each.value["security_rules"]
    content {
      description = lookup(security_rule.value, "description", null)
      direction   = lookup(security_rule.value, "direction", null)
      name        = lookup(security_rule.value, "name", null)
      access      = lookup(security_rule.value, "access", null)
      priority    = lookup(security_rule.value, "priority", null)
      protocol    = lookup(security_rule.value, "protocol", null)
      /*
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)  
      */
      source_port_range            = security_rule.value["source_port_range"] != "" ? security_rule.value["source_port_range"] : null
      destination_port_range       = security_rule.value["destination_port_range"] != "" ? security_rule.value["destination_port_range"] : null
      source_port_ranges           = security_rule.value["source_port_ranges"] != [""] ? security_rule.value["source_port_ranges"] : null
      destination_port_ranges      = security_rule.value["destination_port_ranges"] != [""] ? security_rule.value["destination_port_ranges"] : null
      source_address_prefix        = security_rule.value["source_address_prefix"] != "" ? security_rule.value["source_address_prefix"] : null
      destination_address_prefix   = security_rule.value["destination_address_prefix"] != "" ? security_rule.value["destination_address_prefix"] : null
      source_address_prefixes      = security_rule.value["source_address_prefixes"] != [""] ? security_rule.value["source_address_prefixes"] : null
      destination_address_prefixes = security_rule.value["destination_address_prefixes"] != [""] ? security_rule.value["destination_address_prefixes"] : null
    }
  }
  tags = each.value["tags"]

  depends_on = [
    azurerm_resource_group.gcc_resource_groups
  ]
}

resource "azurerm_subnet_network_security_group_association" "gcc_nsg_associations" {
  for_each                  = var.gcc_network_security_group_associations
  network_security_group_id = azurerm_network_security_group.gcc_nsgs[each.value["nsg_key"]].id
  subnet_id                 = azurerm_subnet.gcc_subnets[each.value["subnet_key"]].id

  depends_on = [
    azurerm_subnet.gcc_subnets,
    azurerm_network_security_group.gcc_nsgs
  ]
}