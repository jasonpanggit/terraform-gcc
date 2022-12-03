module "gcc_scaffolding" {
  source = "../modules/gcc/scaffolding"

  location             = var.location
  random_string_length = var.random_string_length

  gcc_resource_groups  = var.gcc_resource_groups
  gcc_virtual_networks = var.gcc_virtual_networks
  gcc_subnets          = var.gcc_subnets
  gcc_route_tables     = var.gcc_route_tables
  gcc_vnet_peers       = var.gcc_vnet_peers

  gcc_network_security_groups             = var.gcc_network_security_groups
  gcc_network_security_group_associations = var.gcc_network_security_group_associations

  gcc_public_ips = var.gcc_public_ips
  gcc_bastions   = var.gcc_bastions
  gcc_firewalls  = var.gcc_firewalls

  gcc_linux_vm_nics       = var.gcc_linux_vm_nics
  gcc_linux_vms           = var.gcc_linux_vms
  gcc_linux_vm_extensions = var.gcc_linux_vm_extensions

  gcc_private_dns_zones = var.gcc_private_dns_zones

  gcc_private_dns_zone_apim_a_records = var.gcc_private_dns_zone_apim_a_records
  gcc_apims                           = var.gcc_apims

  # AKS
  gcc_aks_clusters                            = var.gcc_aks_clusters
  gcc_aks_cluster_private_dns_zone_vnet_links = var.gcc_aks_cluster_private_dns_zone_vnet_links

}