# Resources
module "key_vault" {
  source = "./modules/keyvault"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.orchestration.name
  tags                       = var.tags
  key_vault_name             = local.key_vault_name
  key_vault_sku_name         = "premium"
  key_vault_keys             = {}
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
}

module "data_factory" {
  source = "./modules/datafactory"

  adf_service_name               = local.adf_service_name
  resource_group_name            = azurerm_resource_group.orchestration.name
  location                       = var.location
  data_factory_global_parameters = merge(local.data_factory_global_parameters_default, var.data_factory_global_parameters)
  data_factory_github_repo       = local.data_factory_github_repo
  data_factory_azure_devops_repo = local.data_factory_azure_devops_repo
  data_factory_published_content = {
    parameters_file = "${path.root}/modules/datafactory/adfContent/ARMTemplateParametersForFactory.json"
    template_file   = "${path.root}/modules/datafactory/adfContent/ARMTemplateForFactory.json"
  }
  custom_template_variables = {
    storage_account_id           = module.storage_account.storage_account_id
    function_shortclip_key       = module.function_shortclip.linux_function_app_primary_key
    function_shortclip_endpoint  = module.function_shortclip.linux_function_app_default_hostname
    function_assisstant_key      = module.function_assisstant.linux_function_app_primary_key
    function_assisstant_endpoint = module.function_assisstant.linux_function_app_default_hostname
    keyvault_endpoint            = module.key_vault.key_vault_uri
    storage_blob_endpoint        = module.storage_account.storage_account_primary_blob_endpoint
  }
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
  customer_managed_key       = null
}

# Role assignments data factory
resource "azurerm_role_assignment" "data_factory_role_assignment_storage_blob_data_owner" {
  description          = "Role Assignment for Data Factory to read and write data"
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = module.data_factory.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_open_ai" {
  description          = "Role Assignment for Data Factory to interact with Open AI models"
  scope                = module.open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.data_factory.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_key_vault_secrets_officer" {
  description          = "Role Assignment for Data Factory to interact with key vault"
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = module.data_factory.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_videoindexer" {
  description          = "Role Assignment for Data Factory to interact with Video Indexer"
  scope                = module.videoindexer.videoindexer_id
  role_definition_name = "Contributor"
  principal_id         = module.data_factory.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}
