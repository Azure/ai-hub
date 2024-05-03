resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_videoindexer" {
  name                       = "logAnalytics"
  target_resource_id         = azapi_resource.videoindexer.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_videoindexer.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_videoindexer.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
