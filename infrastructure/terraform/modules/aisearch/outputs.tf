output "search_service_account_id" {
  description = "The ID of the cognitive service account."
  value       = azurerm_search_service.search_service.id
}

output "search_service_principal_id" {
  description = "Specifies the principal id of the AI Search account."
  sensitive   = false
  value       = azurerm_search_service.search_service.identity[0].principal_id
}