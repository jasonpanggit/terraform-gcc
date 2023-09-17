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

# from virtual desktop
variable "virtual_desktop_workspaces" {
  default = {}
  type    = any
}
variable "virtual_desktop_host_pools" {
  default = {}
  type    = any
}
variable "virtual_desktop_host_pool_registration_infos" {
  default = {}
  type    = any
}
variable "virtual_desktop_application_groups" {
  default = {}
  type    = any
}
variable "virtual_desktop_application_group_associations" {
  default = {}
  type    = any
}
variable "virtual_desktop_vms" {
  default = {}
  type    = any
}
