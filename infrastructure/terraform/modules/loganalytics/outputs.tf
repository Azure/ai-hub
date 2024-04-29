output "log_analytics_id" {
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
  description = "Specifies the resource ID of the Log Analytics Workspace."
  sensitive   = false
}
