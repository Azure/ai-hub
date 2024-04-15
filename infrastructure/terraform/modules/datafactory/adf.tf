
resource "azurerm_data_factory" "example" {
    name                = "example"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    identity {
        type = "SystemAssigned"
    }
}

output "data_factory_name" {
    value = azurerm_data_factory.example.name
}

output "data_factory_id" {
    value = azurerm_data_factory.example.id
}