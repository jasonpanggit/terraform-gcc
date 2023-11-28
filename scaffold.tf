module "resource_group" {
  source = "./modules/scaffolding/resource_group"

  location             = var.location
  random_string_length = var.random_string_length
  resource_groups      = var.resource_groups
}

module "network" {
  source = "./modules/scaffolding/network"

  location         = var.location
  random_string    = module.resource_group.random_string
  resource_groups  = module.resource_group.scaffold_resource_groups
  virtual_networks = var.virtual_networks
  subnets          = var.subnets
  vnet_peers       = var.vnet_peers
}

module "nsg" {
  source = "./modules/scaffolding/network_security_group"

  # from network module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups
  subnets         = module.network.scaffold_subnets

  # NSGs
  network_security_groups             = var.network_security_groups
  network_security_group_associations = var.network_security_group_associations
}

module "firewall" {
  source = "./modules/scaffolding/firewall"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # from vwan module
  vwan_hubs = module.vwan.scaffold_vwan_hubs

  # from private dns resolver module
  # private_dns_resolver_inbound_endpoints = module.private_dns_resolver.scaffold_private_dns_resolver_inbound_endpoints

  # Firewalls
  firewall_public_ips               = var.firewall_public_ips
  firewalls                         = var.firewalls
  firewall_app_rule_collections     = var.firewall_app_rule_collections
  firewall_network_rule_collections = var.firewall_network_rule_collections
}

module "app_gateway" {
  source = "./modules/scaffolding/app_gateway"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # App gateways
  app_gateway_public_ips = var.app_gateway_public_ips
  app_gateways           = var.app_gateways
}

module "bastion" {
  source = "./modules/scaffolding/bastion"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # Bastions
  bastion_public_ips = var.bastion_public_ips
  bastions           = var.bastions
}

module "vm" {
  source = "./modules/scaffolding/virtual_machine"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  vm_nics             = var.vm_nics
  linux_vms           = var.linux_vms
  linux_vm_extensions = var.linux_vm_extensions

  windows_vms           = var.windows_vms
  windows_vm_extensions = var.windows_vm_extensions

  vm_extension_scripts = var.vm_extension_scripts
  firewalls            = module.firewall.scaffold_firewalls
}

module "route_table" {
  source = "./modules/scaffolding/route_table"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # from firewall module
  firewalls = module.firewall.scaffold_firewalls

  # from VM module
  linux_vms = module.vm.scaffold_linux_vms

  # Route tables
  route_tables              = var.route_tables
  route_tables_associations = var.route_tables_associations
}

module "apim" {
  source = "./modules/scaffolding/api_management"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # from private DNS zone module
  private_dns_zones = module.private_dns_zone.scaffold_private_dns_zones

  # APIMs
  internal_apims                            = var.internal_apims
  internal_apims_private_dns_zone_a_records = var.internal_apims_private_dns_zone_a_records
}

module "private_dns_zone" {
  source = "./modules/scaffolding/private_dns_zone"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  virtual_networks = module.network.scaffold_virtual_networks

  # Private DNS zones
  private_dns_zones           = var.private_dns_zones
  private_dns_zone_vnet_links = var.private_dns_zone_vnet_links
}

module "aks_cluster" {
  source = "./modules/scaffolding/kubernetes"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  virtual_networks = module.network.scaffold_virtual_networks
  subnets          = module.network.scaffold_subnets

  # from firewall module
  firewalls = module.firewall.scaffold_firewalls

  # from VM module
  linux_vms = module.vm.scaffold_linux_vms

  # from private dns zone module
  private_dns_zones = module.private_dns_zone.scaffold_private_dns_zones

  # AKSs
  aks_clusters = var.aks_clusters
  # aks_cluster_private_dns_zone_vnet_links = var.aks_cluster_private_dns_zone_vnet_links
  user_assigned_identities = var.user_assigned_identities
}

module "app_service" {
  source = "./modules/scaffolding/app_service"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # ASEv3
  app_service_environments_v3 = var.app_service_environments_v3
  app_service_plans           = var.app_service_plans
}

module "storage_account" {
  source = "./modules/scaffolding/storage_account"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  # from private_dns_zone module
  private_dns_zones = module.private_dns_zone.scaffold_private_dns_zones

  # Storage accounts
  storage_accounts                                            = var.storage_accounts
  storage_account_private_endpoints                           = var.storage_account_private_endpoints
  storage_account_private_endpoint_private_dns_zone_a_records = var.storage_account_private_endpoint_private_dns_zone_a_records
}

module "vwan" {
  source = "./modules/scaffolding/virtual_wan"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  virtual_networks = module.network.scaffold_virtual_networks
  subnets          = module.network.scaffold_subnets

  # from firewall module
  firewalls = module.firewall.scaffold_firewalls

  # from vm module
  linux_vms = module.vm.scaffold_linux_vms

  vwans                 = var.vwans
  vwan_hubs             = var.vwan_hubs
  vwan_hub_connections  = var.vwan_hub_connections
  vwan_hub_route_tables = var.vwan_hub_route_tables
  # vwan_hub_route_table_routes = var.vwan_hub_route_table_routes
}
module "private_dns_resolver" {
  source = "./modules/scaffolding/private_dns_resolver"

  location = var.location
  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  virtual_networks = module.network.scaffold_virtual_networks
  subnets          = module.network.scaffold_subnets

  private_dns_resolvers                    = var.private_dns_resolvers
  private_dns_resolvers_inbound_endpoints  = var.private_dns_resolvers_inbound_endpoints
  private_dns_resolvers_outbound_endpoints = var.private_dns_resolvers_outbound_endpoints
}

module "virtual_desktop" {
  source = "./modules/scaffolding/virtual_desktop"

  # from resource group module
  random_string   = module.resource_group.random_string
  resource_groups = module.resource_group.scaffold_resource_groups

  # from network module
  subnets = module.network.scaffold_subnets

  virtual_desktop_workspaces                          = var.virtual_desktop_workspaces
  virtual_desktop_host_pools                          = var.virtual_desktop_host_pools
  virtual_desktop_host_pool_registration_infos        = var.virtual_desktop_host_pool_registration_infos
  virtual_desktop_desktop_application_groups          = var.virtual_desktop_desktop_application_groups
  virtual_desktop_vms                                 = var.virtual_desktop_vms
  virtual_desktop_vm_nics                             = var.virtual_desktop_vm_nics
  virtual_desktop_vm_aad_join_extensions              = var.virtual_desktop_vm_aad_join_extensions
  virtual_desktop_vm_dsc_extensions                   = var.virtual_desktop_vm_dsc_extensions
  virtual_desktop_fslogix_storage_accounts            = var.virtual_desktop_fslogix_storage_accounts
  virtual_desktop_fslogix_storage_account_file_shares = var.virtual_desktop_fslogix_storage_account_file_shares
  virtual_desktop_user_groups                         = var.virtual_desktop_user_groups
}