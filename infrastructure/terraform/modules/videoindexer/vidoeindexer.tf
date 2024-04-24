resource "azapi_resource" "videoindexer" {
  schema_validation_enabled = false
  type      = "Microsoft.VideoIndexer/accounts@2024-01-01"
  name      = var.videoindexer_name
  parent_id = var.resource_group_id
  location  = var.location
  identity {
    type = "SystemAssigned"
  }
  body = jsonencode({
    properties = {
      "storageServices": {
        "resourceId": var.storage_account_id
      }
    }
  })
  response_export_values = ["properties.accountId"]
}

resource "azurerm_role_assignment" "videoindexer" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azapi_resource.videoindexer.identity[0].principal_id
}