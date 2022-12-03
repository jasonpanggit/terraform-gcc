output "random_string" {
  value = random_string.random_suffix_string.result
}

output "gcc_resource_groups" {
  value = azurerm_resource_group.gcc_resource_groups
}

output "gcc_vnets" {
  value = azurerm_virtual_network.gcc_vnets
}

output "gcc_subnets" {
  value = azurerm_subnet.gcc_subnets
}

output "gcc_firewalls" {
  value = azurerm_firewall.gcc_firewalls
}

output "gcc_linux_proxy_vms" {
  value = azurerm_linux_virtual_machine.gcc_linux_proxy_vms
}