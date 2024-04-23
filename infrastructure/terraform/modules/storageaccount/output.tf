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