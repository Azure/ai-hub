output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "Specifies the resource ID of the Key Vault."
  sensitive   = false
}

output "key_vault_uri" {
  value       = azurerm_key_vault.key_vault.vault_uri
  description = "Specifies the resource ID of the Key Vault."
  sensitive   = false
}

output "key_vault_cmk_id" {
  value       = azapi_resource.key_vault_key.id # azurerm_key_vault_key.key_vault_key.id
  description = "Specifies the resource ID of the Key Vault key used for cmk."
  sensitive   = false
}

output "key_vault_cmk_name" {
  value       = azapi_resource.key_vault_key.name # azurerm_key_vault_key.key_vault_key.name
  description = "Specifies the name of the Key Vault key used for cmk."
  sensitive   = false
}

output "key_vault_uri" {
  value       = azurerm_key_vault.key_vault.vault_uri
  description = "Specifies the URI of the Key Vault."
  sensitive   = false
}

output "key_vault_key_storage_id" {
  value       = azapi_resource.key_vault_key_storage.id # azurerm_key_vault_key.key_vault_key.id
  description = "Specifies the resource ID of the Key Vault key used for cmk."
  sensitive   = false
}

output "key_vault_key_storage_name" {
  value       = azapi_resource.key_vault_key_storage.name # azurerm_key_vault_key.key_vault_key.name
  description = "Specifies the name of the Key Vault key used for cmk."
  sensitive   = false
}
