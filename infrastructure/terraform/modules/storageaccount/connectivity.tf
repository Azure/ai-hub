# resource "azurerm_private_endpoint" "private_endpoint_storage_blob" {
#   name                = "${azurerm_storage_account.storage.name}-blob-pe"
#   location            = var.location
#   resource_group_name = azurerm_storage_account.storage.resource_group_name

#   custom_network_interface_name = "${azurerm_storage_account.storage.name}-blob-nic"
#   private_service_connection {
#     name                           = "${azurerm_storage_account.storage.name}-blob-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_storage_account.storage.id
#     subresource_names              = ["blob"]
#   }
#   subnet_id = var.subnet_id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }

# resource "azurerm_private_endpoint" "private_endpoint_storage_dfs" {
#   name                = "${azurerm_storage_account.storage.name}-dfs-pe"
#   location            = var.location
#   resource_group_name = azurerm_storage_account.storage.resource_group_name

#   custom_network_interface_name = "${azurerm_storage_account.storage.name}-dfs-nic"
#   private_service_connection {
#     name                           = "${azurerm_storage_account.storage.name}-dfs-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_storage_account.storage.id
#     subresource_names              = ["dfs"]
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
#     azurerm_private_endpoint.private_endpoint_storage_blob,
#     azurerm_private_endpoint.private_endpoint_storage_dfs,
#   ]
# }
