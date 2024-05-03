resource "azurerm_role_assignment" "function_rolesassignment_storage_blob_data_owner" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
}

resource "azurerm_role_assignment" "function_rolesassignment_storage_queue_data_contributor" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
}

resource "azurerm_role_assignment" "function_rolesassignment_storage_table_data_contributor" {
  scope                = data.azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
}

resource "azurerm_role_assignment" "function_rolesassignment_key_vault_administrator" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
}
