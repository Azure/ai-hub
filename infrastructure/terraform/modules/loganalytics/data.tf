data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_log_analytics" {
  resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
