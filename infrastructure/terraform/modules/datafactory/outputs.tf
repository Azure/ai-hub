output "data_factory_name" {
  value = azurerm_data_factory.data_factory.name
}

output "data_factory_id" {
  value = azurerm_data_factory.data_factory.id
}

output "data_factory_principal_id" {
  value = azurerm_data_factory.data_factory.identity[0].principal_id
}
