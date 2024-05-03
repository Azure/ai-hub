resource "azurerm_private_endpoint" "private_endpoint_search_service" {
  name                = "${azurerm_search_service.search_service.name}-pe"
  location            = var.location
  resource_group_name = azurerm_search_service.search_service.resource_group_name

  custom_network_interface_name = "${azurerm_search_service.search_service.name}-nic"
  private_service_connection {
    name                           = "${azurerm_search_service.search_service.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_search_service.search_service.id
    subresource_names              = ["searchService"]
  }
  subnet_id = var.subnet_id

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

# resource "time_sleep" "sleep_connectivity" {
#   create_duration = "${var.connectivity_delay_in_seconds}s"

#   depends_on = [
#     azurerm_private_endpoint.private_endpoint_search_service
#   ]
# }
