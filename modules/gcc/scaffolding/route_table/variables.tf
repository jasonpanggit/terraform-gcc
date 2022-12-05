# from networking module
variable "random_string" {
    default = ""
}
variable "gcc_resource_groups" {
  default = {}
  type = any
}
variable "gcc_subnets" {
  default = {}
  type = any
}

# from security module
variable "gcc_firewalls" {
  default = {}
  type    = any
}

# from VM module
variable "gcc_linux_vms" {
  default = {}
  type    = any
}

variable "gcc_route_tables" {
  default = {}
  type    = any
}