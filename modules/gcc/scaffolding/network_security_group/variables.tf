# from networking module
variable "random_string" {
  default = ""
}
variable "gcc_resource_groups" {
  default = {}
  type    = any
}
variable "gcc_subnets" {
  default = {}
  type    = any
}

# NSGs
variable "gcc_network_security_groups" {
  default = {}
  type    = any
}
variable "gcc_network_security_group_associations" {
  default = {}
  type    = any
}