resource "azurerm_role_assignment" "data_factory_role_assignment_storage_blob_data_owner" {
  description          = "Role Assignment for Data Factory to read and write data"
  scope                = module.azure_storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = module.data_factory.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_open_ai_" {
  description          = "Role Assignment for Data Factory to interact with Open AI models"
  scope                = module.azure_open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.azure.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}
