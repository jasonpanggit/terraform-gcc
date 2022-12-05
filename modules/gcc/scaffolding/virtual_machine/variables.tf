# from networking module
variable "random_string" {}
variable "gcc_resource_groups" {
  default = {}
  type = any
}
variable "gcc_subnets" {
  default = {}
  type = any
}

# Linux VMs
variable "gcc_vm_nics" {
  default = {}
  type    = any
}
variable "gcc_linux_vms" {
  default = {}
  type    = any
}
variable "gcc_linux_vm_extensions" {
  default = {}
  type = any
}