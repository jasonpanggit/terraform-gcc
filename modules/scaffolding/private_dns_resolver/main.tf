resource "azurerm_private_dns_resolver" "private_dns_resolvers" {
  for_each            = var.private_dns_resolvers
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  virtual_network_id  = var.virtual_networks[each.value.vnet_key].id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "private_dns_resolvers_inbound_endpoints" {
  for_each = var.private_dns_resolvers_inbound_endpoints
  name     = format("%s-%s", each.value.name, var.random_string)

  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolvers[each.value.private_dns_resolver_key].id
  location                = azurerm_private_dns_resolver.private_dns_resolvers[each.value.private_dns_resolver_key].location
  ip_configurations {
    private_ip_allocation_method = each.value.private_ip_allocation_method
    subnet_id                    = var.subnets[each.value.subnet_key].id
  }
  tags = {}

  depends_on = [azurerm_private_dns_resolver.private_dns_resolvers]
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "private_dns_resolvers_outbound_endpoints" {
  for_each = var.private_dns_resolvers_outbound_endpoints
  name     = format("%s-%s", each.value.name, var.random_string)

  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolvers[each.value.private_dns_resolver_key].id
  location                = azurerm_private_dns_resolver.private_dns_resolvers[each.value.private_dns_resolver_key].location
  subnet_id               = var.subnets[each.value.subnet_key].id
  tags                    = {}

  depends_on = [azurerm_private_dns_resolver.private_dns_resolvers]
}