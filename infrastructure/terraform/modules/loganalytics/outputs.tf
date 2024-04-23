output "log_analytics_id" {
  value       = azurerm_log_analytics_workspace.log_analytics.id
  description = "Specifies the resource ID of the Log Analytics Workspace."
  sensitive   = false
}

output "instrumentation_key" {
  value = azurerm_application_insights.application_insights.instrumentation_key
  sensitive   = true
}

output "app_id" {
  value = azurerm_application_insights.application_insights.app_id
}