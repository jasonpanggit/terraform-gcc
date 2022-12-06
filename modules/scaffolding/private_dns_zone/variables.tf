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

# from integration module
variable "internal_apims" {
  default = {}
  type    = any
}

variable "private_dns_zones" {
  default = {}
  type    = any
}
variable "private_dns_zone_vnet_links" {
  default = {}
  type    = any
}