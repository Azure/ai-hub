# # Assiging RBAC to underlying Storage Account for the function apps - Assistant
# resource "azurerm_role_assignment" "storage_account_blob_owner_assistant" {
#   scope                = data.azurerm_storage_account.functions_storage.id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
# }
# resource "azurerm_role_assignment" "storage_account_queue_contributor_assistant" {
#   scope                = data.azurerm_storage_account.functions_storage.id
#   role_definition_name = "Storage Queue Data Contributor"
#   principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "storage_account_table_contributor_assistant" {
#   scope                = data.azurerm_storage_account.functions_storage.id
#   role_definition_name = "Storage Table Data Contributor"
#   principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
# }


# # Assiging RBAC to underlying Storage Account for the function apps - Shortlcip
# resource "azurerm_role_assignment" "storage_account_blob_owner_shortclip" {
#   scope                = data.azurerm_storage_account.functions_storage.id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "storage_account_queue_contributor_shortclip" {
#   scope                = data.azurerm_storage_account.functions_storage.id
#   role_definition_name = "Storage Queue Data Contributor"
#   principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "storage_account_table_contributor_shortclip" {
#   scope                = data.azurerm_storage_account.functions_storage.id
#   role_definition_name = "Storage Table Data Contributor"
#   principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
# }

# # Assiging RBAC to Storage Account containing videos to download and upload
# resource "azurerm_role_assignment" "video_storage_account_owner_assistant" {
#   scope                = data.azurerm_storage_account.video_storage.id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "video_storage_account_owner_shortclip" {
#   scope                = data.azurerm_storage_account.video_storage.id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
# }


# # Assiging RBAC to OpenAI Account for functions to call the Assistnat APIs
# resource "azurerm_role_assignment" "aoai_cognitive_service_owner_assistant" {
#   scope                = var.cognitive_service_id
#   role_definition_name = "Cognitive Services OpenAI Contributor"
#   principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "aoai_cognitive_service_openai_user_shortclip" {
#   scope                = var.cognitive_service_id
#   role_definition_name = "Cognitive Services OpenAI User"
#   principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
# }

