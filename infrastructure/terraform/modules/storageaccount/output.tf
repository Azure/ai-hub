output "storage_account_id" {
  value       = azurerm_storage_account.storage.id
  description = "Specifies the resource ID of the storage account"
  sensitive   = false
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage.name
  description = "Specifies the name of the storage account"
  sensitive   = false
}

output "storage_account_resource_group_name" {
  value       = azurerm_storage_account.storage.resource_group_name
  description = "Specifies the resource group name of the storage account"
  sensitive   = false
}

output "storage_account_primary_blob_endpoint" {
  value       = azurerm_storage_account.storage.primary_blob_endpoint
  description = "Specifies the primary blob endpoint of the storage account"
  sensitive   = false
}

output "storage_account_primary_connection_string" {
  value       = azurerm_storage_account.storage.primary_connection_string
  description = "Specifies the primary blob endpoint of the storage account"
  sensitive   = true
}
