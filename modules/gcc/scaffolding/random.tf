resource "random_string" "random_suffix_string" {
  length  = var.random_string_length
  special = false
  upper   = false
  lower   = true
  numeric = false
}
