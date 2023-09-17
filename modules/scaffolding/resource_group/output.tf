output "random_string" {
  value = random_string.random_suffix_string.result
}

output "scaffold_resource_groups" {
  value = azurerm_resource_group.resource_groups
}