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

# from private_dns_zone module
variable "private_dns_zones" {
    default = {}
    type = any
}

# Storage accounts
variable "storage_accounts" {
  default = {}
  type    = any
}

variable "storage_account_private_endpoints" {
  default = {}
  type    = any
}

variable "storage_account_private_endpoint_private_dns_zone_a_records" {
  default = {}
  type    = any
}