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
variable "virtual_desktop_workspace" {
  default = {}
  type    = any
}
variable "virtual_desktop_host_pool" {
  default = {}
  type    = any
}
variable "virtual_desktop_host_pool_registration_info" {
  default = {}
  type    = any
}
variable "virtual_desktop_desktop_application_group" {
  default = {}
  type    = any
}
variable "virtual_desktop_desktop_application_group_association" {
  default = {}
  type    = any
}
variable "virtual_desktop_aadj_vms" {
  default = {}
  type    = any
}
variable "virtual_desktop_fslogix_storage_account" {
  default = {}
  type    = any
}