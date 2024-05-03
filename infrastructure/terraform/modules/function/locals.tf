locals {
  function_application_settings_default = {
    AZURE_FUNCTIONS_ENVIRONMENT              = "Production"
    AzureWebJobsSecretStorageType            = "keyvault"
    AzureWebJobsSecretStorageKeyVaultUri     = data.azurerm_key_vault.key_vault.vault_uri
    WEBSITE_CONTENTSHARE                     = var.function_share_name
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = data.azurerm_storage_account.storage_account.primary_blob_connection_string # "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.key_vault_secret_storage_connection_string.versionless_id})"
    # WEBSITE_RUN_FROM_PACKAGE                 = "1"
    # WEBSITE_SKIP_CONTENTSHARE_VALIDATION     = "1"
  }
  function_application_settings = merge(local.function_application_settings_default, var.function_application_settings)

  storage_account = {
    resource_group_name = split("/", var.function_storage_account_id)[4]
    name                = split("/", var.function_storage_account_id)[8]
  }

  key_vault = {
    resource_group_name = split("/", var.function_key_vault_id)[4]
    name                = split("/", var.function_key_vault_id)[8]
  }
}
