variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

# Network module
variable "random_string_length" {
  default = 4
}
variable "location" {}
variable "gcc_resource_groups" {
  type = any
}
variable "gcc_virtual_networks" {
  type = any
}
variable "gcc_vnet_peers" {
  default = {}
  type    = any
}
variable "gcc_subnets" {
  type = any
}

# NSG module
variable "gcc_network_security_groups" {
  default = {}
  type    = any
}
variable "gcc_network_security_group_associations" {
  default = {}
  type    = any
}

# Firewall module
variable "gcc_firewall_public_ips" {
  default = {}
  type    = any
}
variable "gcc_firewalls" {
  default = {}
  type    = any
}

# Bastion module
variable "gcc_bastion_public_ips" {
  default = {}
  type    = any
}
variable "gcc_bastions" {
  default = {}
  type    = any
}

# VM module
variable "gcc_vm_nics" {
  default = {}
  type    = any
}
variable "gcc_linux_vms" {
  default = {}
  type    = any
}
variable "gcc_linux_vm_extensions" {
  default = {}
  type    = any
}

# Route table module
variable "gcc_route_tables" {
  default = {}
  type    = any
}

# API management module
variable "gcc_internal_apims" {
  default = {}
  type    = any
}

# Private DNS zone module
variable "gcc_private_dns_zones" {
  default = {}
  type    = any
}
variable "gcc_private_dns_zone_vnet_links" {
  default = {}
  type    = any
}
variable "gcc_private_dns_zone_apim_a_records" {
  default = {}
  type    = any
}

# Kubernetes module
variable "gcc_aks_clusters" {
  default = {}
  type    = any
}
variable "gcc_aks_cluster_private_dns_zone_vnet_links" {
  default = {}
  type    = any
}