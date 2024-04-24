resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_key_vault" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
