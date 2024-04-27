# UAI - Assiging RBAC to underlying Storage Account for the function apps - Shortlcip & Assistant
resource "azurerm_role_assignment" "uai_storage_account_blob_owner" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_storage_account_queue_contributor" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_storage_account_table_contributor" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

# UAI - Assiging RBAC to Storage Account containing videos to download and upload
resource "azurerm_role_assignment" "uai_video_storage_account_owner" {
  scope                = data.azurerm_storage_account.video_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
}


# UAI - Assiging RBAC to OpenAI Account for functions to call the APIs - Assistant
resource "azurerm_role_assignment" "uai_aoai_cognitive_service_owner" {
  scope                = var.cognitive_service_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

# UAI - Assiging RBAC to OpenAI Account for functions to call the APIs - ShortClip
resource "azurerm_role_assignment" "uai_aoai_cognitive_service_openai_user" {
  scope                = var.cognitive_service_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
}