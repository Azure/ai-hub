resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_data_factory" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_data_factory.data_factory.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
