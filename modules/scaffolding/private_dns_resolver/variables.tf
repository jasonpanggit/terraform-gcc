variable "location" {}
variable "random_string" {
  default = ""
}
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