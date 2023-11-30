# Random
resource "random_string" "random_suffix_string" {
  length  = var.random_string_length
  special = false
  upper   = false
  lower   = true
  numeric = false
}

# Resource groups
resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups
  name     = format("%s-%s", each.value.name, random_string.random_suffix_string.result)
  location = var.location

  depends_on = [
    random_string.random_suffix_string
  ]
}