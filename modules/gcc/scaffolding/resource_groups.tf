# Create resource group
resource "azurerm_resource_group" "gcc_resource_groups" {
  for_each = var.gcc_resource_groups
  name     = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location = var.location

  depends_on = [
    random_string.random_suffix_string
  ]
}