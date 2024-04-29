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

output "key_vault_key_ids" {
  value = {
    for key, value in var.key_vault_keys : key => azurerm_key_vault_key.key_vault_key[key].id
  }
  description = "Specifies the id of the key vault keys."
  sensitive   = false
}

output "key_vault_key_versionless_ids" {
  value = {
    for key, value in var.key_vault_keys : key => azurerm_key_vault_key.key_vault_key[key].resource_versionless_id
  }
  description = "Specifies the versionless id of the key vault keys."
  sensitive   = false
}
