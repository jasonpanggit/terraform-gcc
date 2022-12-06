module "network" {
  source = "./modules/scaffolding/network"

  location             = var.location
  random_string_length = var.random_string_length
  resource_groups      = var.resource_groups
  virtual_networks     = var.virtual_networks
  subnets              = var.subnets
  vnet_peers           = var.vnet_peers
}

module "nsg" {
  source = "./modules/scaffolding/network_security_group"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # NSGs
  network_security_groups             = var.network_security_groups
  network_security_group_associations = var.network_security_group_associations

  depends_on = [
    module.network
  ]
}

module "firewall" {
  source = "./modules/scaffolding/firewall"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # Firewalls
  firewall_public_ips = var.firewall_public_ips
  firewalls           = var.firewalls

  depends_on = [
    module.network
  ]
}

module "bastion" {
  source = "./modules/scaffolding/bastion"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # Bastions
  bastion_public_ips = var.bastion_public_ips
  bastions           = var.bastions

  depends_on = [
    module.network
  ]
}

module "vm" {
  source = "./modules/scaffolding/virtual_machine"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  vm_nics             = var.vm_nics
  linux_vms           = var.linux_vms
  linux_vm_extensions = var.linux_vm_extensions

  depends_on = [
    module.network
  ]
}

module "route_table" {
  source = "./modules/scaffolding/route_table"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # from firewall module
  firewalls = module.firewall.scaffold_firewalls

  # from VM module
  linux_vms = module.vm.scaffold_linux_vms

  # Route tables
  route_tables = var.route_tables

  depends_on = [
    module.network,
    module.firewall,
    module.vm
  ]
}

module "apim" {
  source = "./modules/scaffolding/api_management"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # from private DNS zone module
  private_dns_zones = module.private_dns_zone.scaffold_private_dns_zones

  # APIMs
  internal_apims                            = var.internal_apims
  internal_apims_private_dns_zone_a_records = var.internal_apims_private_dns_zone_a_records

  depends_on = [
    module.network,
    module.private_dns_zone
  ]
}

module "private_dns_zone" {
  source = "./modules/scaffolding/private_dns_zone"

  # from network module
  random_string    = module.network.random_string
  resource_groups  = module.network.scaffold_resource_groups
  virtual_networks = module.network.scaffold_virtual_networks

  # Private DNS zones
  private_dns_zones           = var.private_dns_zones
  private_dns_zone_vnet_links = var.private_dns_zone_vnet_links

  depends_on = [
    module.network
  ]
}

module "aks_cluster" {
  source = "./modules/scaffolding/kubernetes"

  # from network module
  random_string    = module.network.random_string
  resource_groups  = module.network.scaffold_resource_groups
  virtual_networks = module.network.scaffold_virtual_networks
  subnets          = module.network.scaffold_subnets

  # from firewall module
  firewalls = module.firewall.scaffold_firewalls

  # from VM module
  linux_vms = module.vm.scaffold_linux_vms

  # AKSs
  aks_clusters                            = var.aks_clusters
  aks_cluster_private_dns_zone_vnet_links = var.aks_cluster_private_dns_zone_vnet_links

  depends_on = [
    module.network,
    module.firewall,
    module.vm
  ]
}

module "app_service" {
  source = "./modules/scaffolding/app_service"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # ASEv3
  app_service_environments_v3 = var.app_service_environments_v3
  app_service_plans           = var.app_service_plans
}

module "storage_account" {
  source = "./modules/scaffolding/storage_account"

  # from network module
  random_string   = module.network.random_string
  resource_groups = module.network.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # from private_dns_zone module
  private_dns_zones = module.private_dns_zone.scaffold_private_dns_zones

  # Storage accounts
  storage_accounts                                            = var.storage_accounts
  storage_account_private_endpoints                           = var.storage_account_private_endpoints
  storage_account_private_endpoint_private_dns_zone_a_records = var.storage_account_private_endpoint_private_dns_zone_a_records

  depends_on = [
    module.network,
    module.private_dns_zone
  ]
}