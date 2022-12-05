variable "random_string_length" {}
variable "location" {}

variable "gcc_resource_groups" {
  default = {}
  type    = any
}
variable "gcc_virtual_networks" {
  default = {}
  type    = any
}
variable "gcc_vnet_peers" {
  default = {}
  type    = any
}
variable "gcc_subnets" {
  type = any
}