variable "random_string_length" {}
variable "location" {}

variable "resource_groups" {
  default = {}
  type    = any
}