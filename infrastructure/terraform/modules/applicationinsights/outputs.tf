output "application_insights_id" {
  value       = azurerm_application_insights.application_insights.id
  description = "Specifies the resource ID of application insights."
  sensitive   = false
}

output "application_insights_instrumentation_key" {
  value       = azurerm_application_insights.application_insights.instrumentation_key
  description = "Specifies the instrumentation key of application insights."
  sensitive   = false
}

output "application_insights_connection_string" {
  value       = azurerm_application_insights.application_insights.connection_string
  description = "Specifies the connection string of application insights."
  sensitive   = false
}
