variable "random_string" {}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# app gateway public ips
variable "app_gateway_public_ips" {
  default = {}
  type    = any
}

# app gateways 
variable "app_gateways" {
  default = {}
  type    = any
}