output "scaffold_storage_acccounts" {
  value = azurerm_storage_account.storage_accounts
}
output "scaffold_storage_acccount_private_endpoints" {
  value = azurerm_private_endpoint.storage_account_private_endpoints
}
output "scaffold_storage_account_private_endpoint_private_dns_zone_a_records" {
  value = azurerm_private_dns_a_record.storage_account_private_endpoint_private_dns_zone_a_records
}