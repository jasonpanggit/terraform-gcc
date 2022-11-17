/*
resource "azurerm_api_management" "aias_internet_it_apim" {
  name                = var.aias_internet_it_apim_name
  location            = azurerm_resource_group.aias_resource_groups[var.aias_internet_it_apim_rg_key].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[var.aias_internet_it_apim_rg_key].name
  publisher_name      = var.aias_internet_it_apim_publisher_name
  publisher_email     = var.aias_internet_it_apim_publisher_email
  sku_name = "${var.aias_internet_it_apim_sku_name}_${var.aias_internet_it_apim_sku_capacity}"
  virtual_network_type = var.aias_internet_it_apim_type
  
  virtual_network_configuration {
    subnet_id = azurerm_subnet.aias_subnets[var.aias_internet_it_apim_subnet_key].id 
  }

  depends_on = [
    module.aias_internet_vnet,
    azurerm_resource_group.aias_resource_groups,
    azurerm_subnet.aias_subnets
  ]
}

resource "azurerm_api_management" "aias_intranet_it_apim" {
  name                = var.aias_intranet_it_apim_name
  location            = azurerm_resource_group.aias_resource_groups[var.aias_intranet_it_apim_rg_key].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[var.aias_intranet_it_apim_rg_key].name
  publisher_name      = var.aias_intranet_it_apim_publisher_name
  publisher_email     = var.aias_intranet_it_apim_publisher_email
  sku_name = "${var.aias_intranet_it_apim_sku_name}_${var.aias_intranet_it_apim_sku_capacity}"
  virtual_network_type = var.aias_intranet_it_apim_type
  virtual_network_configuration {
    subnet_id = azurerm_subnet.aias_subnets[var.aias_intranet_it_apim_subnet_key].id 
  }

  depends_on = [
    module.aias_intranet_vnet,
    azurerm_resource_group.aias_resource_groups,
    azurerm_subnet.aias_subnets
  ]
}
*/

resource "azurerm_api_management" "aias_apims" {
  for_each             = var.aias_apims
  name                 = "${each.value["name"]}${var.random_string}"
  location             = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name  = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name
  publisher_name       = each.value["publisher_name"]
  publisher_email      = each.value["publisher_email"]
  sku_name             = "${each.value["sku_name"]}_${each.value["sku_capacity"]}"
  virtual_network_type = each.value["type"]

  virtual_network_configuration {
    subnet_id = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_subnet.aias_subnets
  ]
}