output "random_string" {
  value = random_string.random_suffix_string.result
}

output "gcc_resource_groups" {
  value = azurerm_resource_group.gcc_resource_groups
}

output "gcc_virtual_networks" {
  value = azurerm_virtual_network.gcc_virtual_networks
}

output "gcc_subnets" {
  value = azurerm_subnet.gcc_subnets
}