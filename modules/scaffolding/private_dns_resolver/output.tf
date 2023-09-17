output "scaffold_private_dns_resolvers" {
  value = azurerm_private_dns_resolver.private_dns_resolvers
}

output "scaffold_private_dns_resolver_inbound_endpoints" {
  value = azurerm_private_dns_resolver_inbound_endpoint.private_dns_resolvers_inbound_endpoints
}

output "scaffold_private_dns_resolver_outbound_endpoints" {
  value = azurerm_private_dns_resolver_outbound_endpoint.private_dns_resolvers_outbound_endpoints
}