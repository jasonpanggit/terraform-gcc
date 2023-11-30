# Storage accounts
resource "azurerm_storage_account" "storage_accounts" {
  for_each            = var.storage_accounts
  name                = format("%s%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  account_tier                  = each.value.account_tier
  account_replication_type      = each.value.account_replication_type
  public_network_access_enabled = each.value.public_network_access_enabled
  is_hns_enabled                = each.value.is_hns_enabled
  sftp_enabled                  = each.value.sftp_enabled

  identity {
    type = each.value.identity_type
  }
}

# Private endpoints
resource "azurerm_private_endpoint" "storage_account_private_endpoints" {
  for_each            = var.storage_account_private_endpoints
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  subnet_id           = var.subnets[each.value.subnet_key].id

  dynamic "private_service_connection" {
    for_each = each.value.private_service_connections
    content {
      name                           = private_service_connection.value.name
      private_connection_resource_id = azurerm_storage_account.storage_accounts[private_service_connection.value.storage_account_key].id
      is_manual_connection           = private_service_connection.value.is_manual_connection
      subresource_names              = private_service_connection.value.subresource_names
    }
  }

  depends_on = [
    azurerm_storage_account.storage_accounts
  ]
}

# Create DNS A Record
resource "azurerm_private_dns_a_record" "storage_account_private_endpoint_private_dns_zone_a_records" {
  for_each            = var.storage_account_private_endpoint_private_dns_zone_a_records
  name                = azurerm_storage_account.storage_accounts[each.value.storage_account_key].name
  zone_name           = var.private_dns_zones[each.value.private_dns_zone_key].name
  resource_group_name = var.resource_groups[each.value.rg_key].name
  ttl                 = each.value.ttl
  records = [
    azurerm_private_endpoint.storage_account_private_endpoints[each.value.private_endpoint_key].private_service_connection.0.private_ip_address
  ]

  depends_on = [
    azurerm_storage_account.storage_accounts
  ]
}