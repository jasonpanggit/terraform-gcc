# from networking
variable "random_string" {}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# Bastions
variable "bastion_public_ips" {
  default = {}
  type    = any
}
variable "bastions" {
  default = {}
  type    = any
}