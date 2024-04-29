data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_search_service" {
  resource_id = azurerm_search_service.search_service.id
}
