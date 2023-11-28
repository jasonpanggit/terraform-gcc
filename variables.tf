variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

# Network module
variable "random_string_length" {
  default = 4
}
variable "location" {}
variable "resource_groups" {
  type = any
}
variable "virtual_networks" {
  type = any
}
variable "vnet_peers" {
  default = {}
  type    = any
}
variable "subnets" {
  type = any
}

# NSG module
variable "network_security_groups" {
  default = {}
  type    = any
}
variable "network_security_group_associations" {
  default = {}
  type    = any
}

# Firewall module
variable "firewall_public_ips" {
  default = {}
  type    = any
}
variable "firewalls" {
  default = {}
  type    = any
}

# Firewall app rule collections
variable "firewall_app_rule_collections" {
  default = {}
  type    = any
}
# Firewall network rule collections
variable "firewall_network_rule_collections" {
  default = {}
  type    = any
}

# App gateway module
variable "app_gateway_public_ips" {
  default = {}
  type    = any
}
variable "app_gateways" {
  default = {}
  type    = any
}

# Bastion module
variable "bastion_public_ips" {
  default = {}
  type    = any
}
variable "bastions" {
  default = {}
  type    = any
}

# VM module
variable "vm_nics" {
  default = {}
  type    = any
}
variable "linux_vms" {
  default = {}
  type    = any
}
variable "linux_vm_extensions" {
  default = {}
  type    = any
}

variable "windows_vms" {
  default = {}
  type    = any
}
variable "windows_vm_extensions" {
  default = {}
  type    = any
}

# For loading VM extension scripts e.g. bash scripts, pwsh scripts, etc.
variable "vm_extension_scripts" {
  default = {}
  type    = any
}

# Route table module
variable "route_tables" {
  default = {}
  type    = any
}

variable "route_tables_associations" {
  default = {}
  type    = any
}

# API management module
variable "internal_apims" {
  default = {}
  type    = any
}
variable "internal_apims_private_dns_zone_a_records" {
  default = {}
  type    = any
}

# Private DNS zone module
variable "private_dns_zones" {
  default = {}
  type    = any
}
variable "private_dns_zone_vnet_links" {
  default = {}
  type    = any
}

# Kubernetes module
variable "aks_clusters" {
  default = {}
  type    = any
}
variable "aks_cluster_node_pools" {
  default = {}
  type    = any
}
variable "aks_cluster_private_dns_zone_vnet_links" {
  default = {}
  type    = any
}
variable "aks_cluster_jumphost_vm_nics" {
  default = {}
  type    = any
}
variable "aks_cluster_jumphost_vms" {
  default = {}
  type    = any
}
variable "aks_cluster_jumphost_vm_extensions" {
  default = {}
  type    = any
}
variable "user_assigned_identities" {
  default = {}
  type    = any
}

# App service environments v3
variable "app_service_environments_v3" {
  default = {}
  type    = any
}
variable "app_service_plans" {
  default = {}
  type    = any
}

# Storage accounts
variable "storage_accounts" {
  default = {}
  type    = any
}
variable "storage_account_private_endpoints" {
  default = {}
  type    = any
}
variable "storage_account_private_endpoint_private_dns_zone_a_records" {
  default = {}
  type    = any
}

# Virtual WAN
variable "vwans" {
  default = {}
  type    = any
}
# Virtual WAN Hubs
variable "vwan_hubs" {
  default = {}
  type    = any
}
# Virtual WAN Connections
variable "vwan_hub_connections" {
  default = {}
  type    = any
}
# Virtual WAN Route Tables
variable "vwan_hub_route_tables" {
  default = {}
  type    = any
}
# Virtual WAN Route Table Routes
variable "vwan_hub_route_table_routes" {
  default = {}
  type    = any
}

# Private DNS resolvers
variable "private_dns_resolvers" {
  default = {}
  type    = any
}
variable "private_dns_resolvers_inbound_endpoints" {
  default = {}
  type    = any
}

variable "private_dns_resolvers_outbound_endpoints" {
  default = {}
  type    = any
}

# Virtual desktop
variable "virtual_desktop_workspaces" {
  default = {}
  type    = any
}
variable "virtual_desktop_host_pools" {
  default = {}
  type    = any
}
variable "virtual_desktop_host_pool_registration_infos" {
  default = {}
  type    = any
}
variable "virtual_desktop_desktop_application_groups" {
  default = {}
  type    = any
}
variable "virtual_desktop_vms" {
  default = {}
  type    = any
}
variable "virtual_desktop_vm_nics" {
  default = {}
  type    = any
}
variable "virtual_desktop_vm_aad_join_extensions" {
  default = {}
  type    = any
}
variable "virtual_desktop_vm_dsc_extensions" {
  default = {}
  type    = any
}
variable "virtual_desktop_fslogix_storage_accounts" {
  default = {}
  type    = any
}
variable "virtual_desktop_fslogix_storage_account_file_shares" {
  default = {}
  type    = any
}
variable "virtual_desktop_user_groups" {
  default = {}
  type    = any
}