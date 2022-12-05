# from networking module
variable "random_string" {}
variable "gcc_resource_groups" {
  default = {}
  type = any
}
variable "gcc_virtual_networks" {
  default = {}
  type = any
}
variable "gcc_subnets" {
  default = {}
  type = any
}

# from security module
variable "gcc_firewalls" {
  default = {}
  type    = any
}

# AKS private clusters
variable "gcc_aks_clusters" {
  default = {}
  type    = any
}
variable "gcc_aks_cluster_private_dns_zone_vnet_links" {
  default = {}
  type    = any
}