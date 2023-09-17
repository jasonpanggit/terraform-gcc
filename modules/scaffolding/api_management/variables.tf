# from networking module
variable "random_string" {}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# from private_dns_zone module
variable "private_dns_zones" {
  default = {}
  type    = any
}

# Internal APIMs
variable "internal_apims" {
  default = {}
  type    = any
}

variable "internal_apims_private_dns_zone_a_records" {
  default = {}
  type    = any
}

