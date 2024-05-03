resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_linux_logic_app" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_logic_app_standard.logic_app_standard.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_logic_app.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_logic_app.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
