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

# from vwan module
variable "vwan_hubs" {
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

# from private dns resolver module
# variable "private_dns_resolver_inbound_endpoints" {
#   default = {}
#   type    = any
# }