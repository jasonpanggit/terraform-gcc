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

# from security module
variable "firewalls" {
  default = {}
  type    = any
}

# from VM module
variable "linux_vms" {
  default = {}
  type    = any
}

variable "route_tables" {
  default = {}
  type    = any
}

variable "route_tables_associations" {
  default = {}
  type    = any
}