# from networking module
variable "random_string" {}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "virtual_networks" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# from security module
variable "firewalls" {
  default = {}
  type    = any
}

# from vm module
variable "linux_vms" {
  default = {}
  type    = any
}

# private dns zone module
variable "private_dns_zones" {
  default = {}
  type    = any
}

# AKS private clusters
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
variable "user_assigned_identities" {
  default = {}
  type    = any
}