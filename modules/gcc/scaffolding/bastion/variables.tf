# from networking
variable "random_string" {}
variable "gcc_resource_groups" {
  default = {}
  type = any
}
variable "gcc_subnets" {
  default = {}
  type = any
}

# Bastions
variable "gcc_bastion_public_ips" {
  default = {}
  type    = any
}
variable "gcc_bastions" {
  default = {}
  type    = any
}