data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_function" {
  resource_id = azurerm_linux_function_app.assistant_function.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_function_helloworld" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_linux_function_app.helloworld_function.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}


resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_function_assistant" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_linux_function_app.assistant_function.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_function_shortclip" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_linux_function_app.shortclip_function.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}