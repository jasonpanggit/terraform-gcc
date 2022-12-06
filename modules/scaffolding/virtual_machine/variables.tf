# from networking module
variable "random_string" {}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# Linux VMs
variable "vm_nics" {
  default = {}
  type    = any
}
variable "linux_vms" {
  default = {}
  type    = any
}
variable "linux_vm_extensions" {
  default = {}
  type    = any
}