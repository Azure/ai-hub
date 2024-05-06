module "storage_account_shortclip" {
  source = "./modules/storageaccount"

  location                        = local.location
  resource_group_name             = azurerm_resource_group.shortclip.name
  tags                            = var.tags
  storage_account_name            = local.storage_account_name_shortclip
  storage_account_container_names = []
  storage_account_share_names = [
    local.function_name_shortclip
  ]
  storage_account_shared_access_key_enabled = true
  log_analytics_workspace_id                = module.azure_log_analytics.log_analytics_id
  subnet_id                                 = var.subnet_id
  customer_managed_key                      = null
}

module "application_insights_shortclip" {
  source = "./modules/applicationinsights"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.shortclip.name
  tags                       = var.tags
  application_insights_name  = local.application_insights_name_shortclip
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
}

module "key_vault_shortclip" {
  source = "./modules/keyvault"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.shortclip.name
  tags                       = var.tags
  key_vault_name             = local.key_vault_name_shortclip
  key_vault_sku_name         = "premium"
  key_vault_keys             = {}
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
}

module "user_assigned_identity_shortclip" {
  source = "./modules/managedidentity"

  location                    = local.location
  resource_group_name         = azurerm_resource_group.shortclip.name
  tags                        = var.tags
  user_assigned_identity_name = local.user_assigned_identity_name_shortclip
}

module "function_shortclip" {
  source = "./modules/function"

  location            = local.location
  resource_group_name = azurerm_resource_group.shortclip.name
  tags                = var.tags
  function_name       = local.function_name_shortclip
  function_application_settings = {
    # Function config settings
    BUILD_FLAGS                    = "UseExpressBuild"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    FUNCTIONS_WORKER_RUNTIME       = "python"
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    TaskHubName                    = "shortclip"
    # App specific settings
    STORAGE_DOMAIN_NAME           = replace(trimprefix(module.storage_account.storage_account_primary_blob_endpoint, "https://"), "/", "")
    STORAGE_CONTAINER_NAME        = local.container_name_shortclip
    AZURE_OPEN_AI_API_VERSION     = "2024-02-15-preview"
    AZURE_OPEN_AI_DEPLOYMENT_NAME = local.gpt_model_name
    AZURE_OPEN_AI_BASE_URL        = module.open_ai.cognitive_account_endpoint
  }
  function_always_on                                = false
  function_code_path                                = "${path.module}/modules/functions/rag-video-tagging/code/durablefunction"
  function_storage_account_id                       = module.storage_account_shortclip.storage_account_id
  function_share_name                               = local.function_name_shortclip
  function_key_vault_id                             = module.key_vault_shortclip.key_vault_id
  function_user_assigned_identity_id                = module.user_assigned_identity_shortclip.user_assigned_identity_id
  function_sku                                      = var.function_sku
  function_application_insights_instrumentation_key = module.application_insights_shortclip.application_insights_instrumentation_key
  function_application_insights_connection_string   = module.application_insights_shortclip.application_insights_connection_string
  log_analytics_workspace_id                        = module.azure_log_analytics.log_analytics_id
  subnet_id                                         = var.subnet_id
  customer_managed_key                              = null
}

# UAI role assignments
resource "azurerm_role_assignment" "uai_shortclip_role_assignment_key_vault_secrets_user" {
  description          = "Role Assignment for uai to read secrets"
  scope                = module.key_vault_shortclip.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.user_assigned_identity_shortclip.user_assigned_identity_principal_id
  principal_type       = "ServicePrincipal"
}

# Function role assignment
resource "azurerm_role_assignment" "function_shortclip_role_assignment_storage_blob_data_contributor" {
  description          = "Role Assignment for Data Factory to interact with Open AI models"
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.function_shortclip.linux_function_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "function_shortclip_role_assignment_cognitive_services_openai_user" {
  description          = "Role Assignment for Function to interact with Azure Open AI"
  scope                = module.open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.function_shortclip.linux_function_app_principal_id
  principal_type       = "ServicePrincipal"
}
