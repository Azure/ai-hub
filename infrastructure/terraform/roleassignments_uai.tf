resource "azurerm_role_assignment" "uai_role_assignment_key_vault_crypto_service_encryption_user" {
  description          = "Role Assignment for UAI to read keys for CMK"
  scope                = module.azure_key_vault.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = module.azure_managed_identity.user_assigned_identity_principal_id
  principal_type       = "ServicePrincipal"
}
