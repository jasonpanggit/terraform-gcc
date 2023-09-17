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
variable "vnet_peers" {
  default = {}
  type    = any
}
variable "subnets" {
  type = any
}