resource "azapi_resource" "videoindexer" {
  name      = var.videoindexer_name
  type      = "Microsoft.VideoIndexer/accounts@2024-01-01"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = var.location
  tags      = var.tags
  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    properties = {
      storageServices = {
        resourceId = var.storage_account_id
      }
    }
  })
  response_export_values = ["properties.accountId"]
}
