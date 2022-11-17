variable "random_string_length" {}
variable "location" {}

variable "aias_resource_groups" {
  type = any
}
variable "aias_virtual_networks" {
  type = any
}
variable "aias_vnet_peers" {
  default = {}
  type    = any
}
variable "aias_subnets" {
  type = any
}
#variable "aias_subnet_route_tables" {
#  default = {}
#  type = any
#}
variable "aias_network_security_groups" {
  default = {}
  type    = any
}
variable "aias_network_security_group_associations" {
  default = {}
  type    = any
}

variable "aias_bastions" {
  default = {}
  type    = any
}

variable "aias_public_ips" {
  default = {}
  type    = any
}

variable "aias_firewalls" {
  default = {}
  type    = any
}

variable "aias_linux_vm_nics" {
  default = {}
  type    = any
}
variable "aias_linux_vms" {
  default = {}
  type    = any
}

variable "aias_apims" {
  default = {}
  type    = any
}

variable "aias_private_dns_zones" {
  default = {}
  type    = any
}
variable "aias_private_dns_zone_apim_a_records" {
  default = {}
  type    = any
}
