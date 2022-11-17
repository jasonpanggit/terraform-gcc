# Create resource group
resource "azurerm_resource_group" "aias_resource_groups" {
  for_each = var.aias_resource_groups
  name     = "${each.value["name"]}${var.random_string}"
  location = var.location
}