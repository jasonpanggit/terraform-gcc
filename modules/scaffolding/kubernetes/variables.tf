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

# AKS private clusters
variable "aks_clusters" {
  default = {}
  type    = any
}
variable "aks_cluster_private_dns_zone_vnet_links" {
  default = {}
  type    = any
}