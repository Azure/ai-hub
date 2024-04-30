resource "azurerm_role_assignment" "function_rolesassignment_key_vault_administrator" {
  scope                = data.azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_logic_app_standard.logic_app_standard.identity[0].principal_id
}
