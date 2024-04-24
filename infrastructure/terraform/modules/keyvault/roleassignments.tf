resource "azurerm_role_assignment" "umi_role_assignment_key_vault" {
  scope                            = azurerm_key_vault.key_vault.id
  role_definition_name             = "Key Vault Crypto Service Encryption User"
  principal_id                     = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
  skip_service_principal_aad_check = true
}
