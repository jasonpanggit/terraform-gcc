# from networking module
variable "random_string" {}
variable "gcc_resource_groups" {
  default = {}
  type    = any
}
variable "gcc_virtual_networks" {
  default = {}
  type    = any
}

# from integration module
variable "gcc_internal_apims" {
  default = {}
  type    = any
}

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
