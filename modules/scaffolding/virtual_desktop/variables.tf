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
variable "virtual_desktop_desktop_application_groups" {
  default = {}
  type    = any
}
variable "virtual_desktop_vms" {
  default = {}
  type    = any
}
variable "virtual_machine_vms" {
  default = {}
  type    = any
}
variable "virtual_desktop_vm_nics" {
  default = {}
  type    = any
}
variable "virtual_desktop_vm_aad_join_extensions" {
  default = {}
  type    = any
}
variable "virtual_desktop_vm_dsc_extensions" {
  default = {}
  type    = any
}
variable "virtual_desktop_fslogix_storage_accounts" {
  default = {}
  type    = any
}
variable "virtual_desktop_fslogix_storage_account_file_shares" {
  default = {}
  type    = any
}
variable "virtual_desktop_user_groups" {
  default = {}
  type    = any
}