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

variable "gcc_internal_apims" {
  default = {}
  type = any
}

