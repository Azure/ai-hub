resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_log_analytics" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_log_analytics.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_log_analytics.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
