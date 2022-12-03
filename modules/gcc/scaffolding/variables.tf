variable "random_string_length" {}
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
variable "gcc_route_tables" {
  default = {}
  type = any
}
variable "gcc_network_security_groups" {
  default = {}
  type    = any
}
variable "gcc_network_security_group_associations" {
  default = {}
  type    = any
}

variable "gcc_bastions" {
  default = {}
  type    = any
}

variable "gcc_public_ips" {
  default = {}
  type    = any
}

variable "gcc_firewalls" {
  default = {}
  type    = any
}

variable "gcc_linux_proxy_vm_nics" {
  default = {}
  type    = any
}
variable "gcc_linux_proxy_vms" {
  default = {}
  type    = any
}

variable "gcc_apims" {
  default = {}
  type    = any
}

variable "gcc_private_dns_zones" {
  default = {}
  type    = any
}
variable "gcc_private_dns_zone_apim_a_records" {
  default = {}
  type    = any
}
