# Create Log Analytics workspace

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.log_analytics_resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_in_days
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_log_analytics" {
  resource_id = azurerm_log_analytics_workspace.log_analytics.id
}

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
