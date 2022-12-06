output "random_string" {
  value = random_string.random_suffix_string.result
}

output "scaffold_resource_groups" {
  value = azurerm_resource_group.resource_groups
}

output "scaffold_virtual_networks" {
  value = azurerm_virtual_network.virtual_networks
}

output "scaffold_subnets" {
  value = azurerm_subnet.subnets
}