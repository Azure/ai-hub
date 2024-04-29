
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_search_service" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_search_service.search_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_search_service.log_category_groups
    content {
      category_group = entry.value
    }
  }
}
