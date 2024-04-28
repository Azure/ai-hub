output "azurerm_cognitive_account_service_id" {
  description = "The ID of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_service.id
}

output "azurerm_cognitive_account_endpoint" {
  description = "The base URL of the cognitive service account."
  value       = azurerm_cognitive_account.cognitive_service.endpoint
}
