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

# Firewalls
variable "firewall_public_ips" {
  default = {}
  type    = any
}
variable "firewalls" {
  default = {}
  type    = any
}

# Firewall app rules
variable "firewall_app_rules" {
  default = {}
  type    = any
}