data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_videoindexer" {
  resource_id = azapi_resource.videoindexer.id
}
