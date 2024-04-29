module "azure_open_ai" {
  source                     = "./modules/aoai"
  location                   = local.location
  resource_group_name        = azurerm_resource_group.ingestion.name
  cognitive_service_name     = local.azure_open_ai_name
  cognitive_service_kind     = "OpenAI"
  cognitive_service_sku      = "S0"
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  cmk_key_vault_id           = module.azure_key_vault.key_vault_id
  cmk_key_name               = module.azure_key_vault.key_vault_cmk_name
  key_vault_uri              = module.azure_key_vault.key_vault_uri
  subnet_id                  = var.subnet_id
}

module "azure_storage_account" {
  source                     = "./modules/storageaccount"
  location                   = local.location
  storage_account_name       = local.storage_account_name
  resource_group_name        = azurerm_resource_group.ingestion.name
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                  = var.subnet_id
  cmk_key_vault_id           = module.azure_key_vault.key_vault_id
  cmk_key_name               = module.azure_key_vault.key_vault_key_storage_name
  depends_on                 = [module.azure_key_vault]
}

module "azure_log_analytics" {
  source                            = "./modules/loganalytics"
  location                          = local.location
  log_analytics_name                = local.log_analytics_name
  log_analytics_sku                 = var.log_analytics_sku
  log_analytics_retention_in_days   = 30
  log_analytics_resource_group_name = azurerm_resource_group.ingestion.name
}

module "azure_key_vault" {
  source                     = "./modules/keyvault"
  key_vault_name             = local.azure_key_vault_name
  location                   = local.location
  resource_group_name        = azurerm_resource_group.ingestion.name
  key_vault_sku_name         = var.key_vault_sku
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                  = var.subnet_id
}

module "azure_managed_identity" {
  source                      = "./modules/managedidentity"
  location                    = local.location
  user_assigned_identity_name = local.azure_managed_identity_name
  resource_group_name         = azurerm_resource_group.ingestion.name
}

module "videoindexer" {
  source             = "./modules/videoindexer"
  videoindexer_name  = local.videoindexer_name
  resource_group_id  = azurerm_resource_group.ingestion.id
  location           = local.location
  storage_account_id = module.azure_storage_account.storage_account_id
}


module "data_factory" {
  source = "./modules/datafactory"

  adf_service_name               = local.adf_service_name
  resource_group_name            = azurerm_resource_group.ingestion.name
  location                       = var.location
  data_factory_global_parameters = merge(local.data_factory_global_parameters_default, var.data_factory_global_parameters)
  data_factory_github_repo       = local.data_factory_github_repo
  data_factory_azure_devops_repo = local.data_factory_azure_devops_repo
  data_factory_published_content = {
    parameters_file = "${path.root}/modules/datafactory/adfContent/ARMTemplateParametersForFactory.json"
    template_file   = "${path.root}/modules/datafactory/adfContent/ARMTemplateForFactory.json"
  }
  custom_template_variables = {
    storage_account_id           = module.azure_storage_account.storage_account_id
    function_shortclip_key       = ""
    function_shortclip_endpoint  = module.functions.function_shortclip_endpoint
    function_assisstant_key      = ""
    function_assisstant_endpoint = module.functions.function_assisstant_endpoint
    keyvault_endpoint            = module.azure_key_vault.key_vault_uri
    storage_blob_endpoint        = module.azure_storage_account.storage_account_primary_blob_endpoint
  }
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
}


module "azure_storage_account_functions" {
  source                     = "./modules/storageaccount"
  location                   = local.location
  storage_account_name       = local.function_storage_account_name
  resource_group_name        = azurerm_resource_group.ingestion.name
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                 = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                  = var.subnet_id
  cmk_key_vault_id           = module.azure_key_vault.key_vault_id
  cmk_key_name               = module.azure_key_vault.key_vault_key_storage_name
  depends_on                 = [module.azure_key_vault]
}

module "functions" {
  source                           = "./modules/functions"
  location                         = local.location
  resource_group_name              = azurerm_resource_group.ingestion.name
  function_service_plan_name       = local.function_service_plan_name
  functions_storage_account_id     = module.azure_storage_account_functions.storage_account_id
  video_storage_account_id         = module.azure_storage_account.storage_account_id
  function_sku                     = var.function_sku
  helloworld_function_service_name = local.azure_function_name_helloworld
  assistant_function_service_name  = local.azure_function_name_assistant
  shortclip_function_service_name  = local.azure_function_name_shortclip
  user_assigned_identity_id        = module.azure_managed_identity.user_assigned_identity_id
  cognitive_service_id             = module.azure_open_ai.azurerm_cognitive_account_service_id
  cognitive_service_endpoint       = module.azure_open_ai.azurerm_cognitive_account_endpoint
  log_analytics_workspace_id       = module.azure_log_analytics.log_analytics_id
  instrumentation_key              = module.azure_log_analytics.instrumentation_key
  app_id                           = module.azure_log_analytics.app_id
  azapi_resource_videoindexer_id   = module.videoindexer.azapi_resource_videoindexer_id
}