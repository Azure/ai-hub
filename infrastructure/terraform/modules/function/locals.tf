locals {
  function_application_settings_default = {
    AZURE_FUNCTIONS_ENVIRONMENT          = "Production"
    WEBSITE_RUN_FROM_PACKAGE             = "1"
    AzureWebJobsSecretStorageType        = "keyvault"
    AzureWebJobsSecretStorageKeyVaultUri = var.function_key_vault_id
    # WEBSITE_SKIP_CONTENTSHARE_VALIDATION     = "1"
    # WEBSITE_CONTENTSHARE                     = azurerm_storage_share.storage_share.name
    # WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.key_vault_secret_storage_connection_string.versionless_id})"
  }
  function_application_settings = merge(local.function_application_settings_default, var.function_application_settings)

  storage_account = {
    resource_group_name = split("/", var.function_storage_account_id)[4]
    name                = split("/", var.function_storage_account_id)[8]
  }
}
