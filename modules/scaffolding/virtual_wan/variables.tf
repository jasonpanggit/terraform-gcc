# from networking
variable "random_string" {}
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

# from firewall module
variable "firewalls" {
  default = {}
  type    = any
}

# from virtual_machine module
variable "linux_vms" {
  default = {}
  type    = any
}


# Virtual WAN
variable "vwans" {
  default = {}
  type    = any
}
# Virtual WAN Hubs
variable "vwan_hubs" {
  default = {}
  type    = any
}
# Virtual WAN Connections
variable "vwan_hub_connections" {
  default = {}
  type    = any
}
# Virtual WAN Route Tables
variable "vwan_hub_route_tables" {
  default = {}
  type    = any
}
# Virtual WAN Route Table Routes
variable "vwan_hub_route_table_routes" {
  default = {}
  type    = any
}

