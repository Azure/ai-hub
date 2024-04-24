# resource "azurerm_private_endpoint" "private_endpoint_data_factory" {
#   name                = "${azurerm_data_factory.data_factory.name}-pe"
#   location            = var.location
#   resource_group_name = azurerm_data_factory.data_factory.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_data_factory.data_factory.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_data_factory.data_factory.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_data_factory.data_factory.id
#     subresource_names              = ["vault"]
#   }
#   subnet_id = var.subnet_id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }

# resource "time_sleep" "sleep_connectivity" {
#   create_duration = "${var.connectivity_delay_in_seconds}s"

#   depends_on = [
#     azurerm_private_endpoint.private_endpoint_data_factory
#   ]
# }
