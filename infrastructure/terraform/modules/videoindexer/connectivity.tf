# resource "azurerm_private_endpoint" "private_endpoint_videoindexer" {
#   name                = "${azapi_resource.videoindexer.name}-pe"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azapi_resource.videoindexer.name}-nic"
#   private_service_connection {
#     name                           = "${azapi_resource.videoindexer.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azapi_resource.videoindexer.id
#     subresource_names              = ["TODO"]
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
#     azurerm_private_endpoint.private_endpoint_videoindexer
#   ]
# }
