resource "azurerm_role_assignment" "videoindexer" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azapi_resource.videoindexer.identity[0].principal_id
}
