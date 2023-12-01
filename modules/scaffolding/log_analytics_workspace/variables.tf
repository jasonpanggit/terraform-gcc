# from networking module
variable "random_string" {
  default = ""
}
variable "resource_groups" {
  default = {}
  type    = any
}

variable "log_analytics_workspaces" {
  default = {}
  type    = any
}