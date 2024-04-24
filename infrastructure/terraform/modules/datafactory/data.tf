data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_data_factory" {
  resource_id = azurerm_data_factory.data_factory.id
}
