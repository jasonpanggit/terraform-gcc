# from networking module
variable "random_string" {
  default = ""
}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# NSGs
variable "network_security_groups" {
  default = {}
  type    = any
}
variable "network_security_group_associations" {
  default = {}
  type    = any
}