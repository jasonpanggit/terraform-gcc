output "random_string" {
  value = random_string.random_suffix_string.result
}

output "aias_resource_groups" {
  value = azurerm_resource_group.aias_resource_groups
}

output "aias_subnets" {
  value = azurerm_subnet.aias_subnets
}

output "aias_firewalls" {
  value = azurerm_firewall.aias_firewalls
}

output "aias_linux_vms" {
  value = azurerm_linux_virtual_machine.aias_linux_vms
}