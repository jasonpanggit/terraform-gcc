module "gcc_network" {
  source = "../modules/gcc/scaffolding/network"

  location             = var.location
  random_string_length = var.random_string_length
  gcc_resource_groups  = var.gcc_resource_groups
  gcc_virtual_networks = var.gcc_virtual_networks
  gcc_subnets          = var.gcc_subnets
  gcc_vnet_peers       = var.gcc_vnet_peers
}

module "gcc_nsg" {
  source = "../modules/gcc/scaffolding/network_security_group"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_subnets         = module.gcc_network.gcc_subnets

  # NSGs
  gcc_network_security_groups             = var.gcc_network_security_groups
  gcc_network_security_group_associations = var.gcc_network_security_group_associations
}

module "gcc_firewall" {
  source = "../modules/gcc/scaffolding/firewall"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_subnets         = module.gcc_network.gcc_subnets

  # Firewalls
  gcc_firewall_public_ips = var.gcc_firewall_public_ips
  gcc_firewalls           = var.gcc_firewalls
}

module "gcc_bastion" {
  source = "../modules/gcc/scaffolding/bastion"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_subnets         = module.gcc_network.gcc_subnets

  # Bastions
  gcc_bastion_public_ips = var.gcc_bastion_public_ips
  gcc_bastions           = var.gcc_bastions
}

module "gcc_vm" {
  source = "../modules/gcc/scaffolding/virtual_machine"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_subnets         = module.gcc_network.gcc_subnets

  # Squid proxy vms
  gcc_vm_nics       = var.gcc_vm_nics
  gcc_linux_vms           = var.gcc_linux_vms
  gcc_linux_vm_extensions = var.gcc_linux_vm_extensions
}

module "gcc_route_table" {
  source = "../modules/gcc/scaffolding/route_table"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_subnets         = module.gcc_network.gcc_subnets

  # from firewall module
  gcc_firewalls = module.gcc_firewall.gcc_firewalls

  # from VM module
  gcc_linux_vms = module.gcc_vm.gcc_linux_vms

  # Route tables
  gcc_route_tables = var.gcc_route_tables
}

module "gcc_apim" {
  source = "../modules/gcc/scaffolding/api_management"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_subnets         = module.gcc_network.gcc_subnets

  # APIMs
  gcc_internal_apims = var.gcc_internal_apims
}

module "gcc_private_dns_zone" {
  source = "../modules/gcc/scaffolding/private_dns_zone"

  # from network module
  random_string       = module.gcc_network.random_string
  gcc_resource_groups = module.gcc_network.gcc_resource_groups
  gcc_virtual_networks = module.gcc_network.gcc_virtual_networks

  # from APIM module
  gcc_internal_apims = module.gcc_apim.gcc_internal_apims

  # Private DNS zones
  gcc_private_dns_zones               = var.gcc_private_dns_zones
  gcc_private_dns_zone_apim_a_records = var.gcc_private_dns_zone_apim_a_records
}

module "gcc_aks_cluster" {
  source = "../modules/gcc/scaffolding/kubernetes"

  # from network module
  random_string        = module.gcc_network.random_string
  gcc_resource_groups  = module.gcc_network.gcc_resource_groups
  gcc_virtual_networks = module.gcc_network.gcc_virtual_networks
  gcc_subnets          = module.gcc_network.gcc_subnets

  # from firewall module
  gcc_firewalls = module.gcc_firewall.gcc_firewalls

  # AKSs
  gcc_aks_clusters                            = var.gcc_aks_clusters
  gcc_aks_cluster_private_dns_zone_vnet_links = var.gcc_aks_cluster_private_dns_zone_vnet_links
}