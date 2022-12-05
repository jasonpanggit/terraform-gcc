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

# Firewalls
variable "gcc_firewall_public_ips" {
  default = {}
  type    = any
}
variable "gcc_firewalls" {
  default = {}
  type    = any
}