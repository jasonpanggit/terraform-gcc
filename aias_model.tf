resource "random_string" "random_suffix_string" {
  length  = var.random_string_length
  special = false
  upper   = false
  lower   = true
  numeric = false
}

# This module generates the aias scaffolding of vnets, subnets, etc. based on the variables' values
module "aias_model" {
  source = "./modules/aias/models/scaffolding"

  location      = var.location
  random_string = random_string.random_suffix_string.result

  aias_resource_groups  = var.aias_resource_groups
  aias_virtual_networks = var.aias_virtual_networks
  aias_subnets          = var.aias_subnets
  aias_vnet_peers       = var.aias_vnet_peers

  aias_network_security_groups             = var.aias_network_security_groups
  aias_network_security_group_associations = var.aias_network_security_group_associations

  aias_public_ips = var.aias_public_ips
  aias_bastions   = var.aias_bastions
  aias_firewalls  = var.aias_firewalls

  aias_linux_vm_nics = var.aias_linux_vm_nics
  aias_linux_vms     = var.aias_linux_vms

  aias_private_dns_zones = var.aias_private_dns_zones

  aias_private_dns_zone_apim_a_records = var.aias_private_dns_zone_apim_a_records
  aias_apims                           = var.aias_apims

  depends_on = [
    random_string.random_suffix_string
  ]
}