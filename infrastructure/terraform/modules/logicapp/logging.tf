resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_linux_function_app" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_linux_function_app.linux_function_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_linux_function_app.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_linux_function_app.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
