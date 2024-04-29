resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_cognitive_service" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_cognitive_account.cognitive_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
