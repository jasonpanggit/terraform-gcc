# from networking
variable "random_string" {}
variable "resource_groups" {
  default = {}
  type    = any
}
variable "subnets" {
  default = {}
  type    = any
}

# App service environments v3
variable "app_service_environments_v3" {
  default = {}
  type    = any
}
variable "app_service_plans" {
  default = {}
  type    = any
}