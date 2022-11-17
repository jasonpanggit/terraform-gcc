# Create resource group
resource "azurerm_resource_group" "aias_resource_groups" {
  for_each = var.aias_resource_groups
  name     = "${each.value["name"]}${random_string.random_suffix_string.result}"
  location = var.location

  depends_on = [
    random_string.random_suffix_string
  ]
}