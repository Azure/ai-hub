# Resources
module "storage_account_orchestration" {
  source = "./modules/storageaccount"

  location                        = local.location
  resource_group_name             = azurerm_resource_group.shortclip.name
  tags                            = var.tags
  storage_account_name            = local.storage_account_name_orchestration
  storage_account_container_names = []
  storage_account_share_names = [
    local.logic_app_name
  ]
  storage_account_shared_access_key_enabled = true
  log_analytics_workspace_id                = module.azure_log_analytics.log_analytics_id
  subnet_id                                 = var.subnet_id
  customer_managed_key                      = null
}

module "application_insights_orchestration" {
  source = "./modules/applicationinsights"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.shortclip.name
  tags                       = var.tags
  application_insights_name  = local.application_insights_name_shortclip
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
}

module "key_vault_orchestration" {
  source = "./modules/keyvault"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.orchestration.name
  tags                       = var.tags
  key_vault_name             = local.key_vault_name_orchestration
  key_vault_sku_name         = "premium"
  key_vault_keys             = {}
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
}

module "logic_app_orchestration" {
  source = "./modules/logicapp"

  location            = local.location
  resource_group_name = azurerm_resource_group.orchestration.name
  tags                = var.tags
  logic_app_name      = local.logic_app_name
  logic_app_application_settings = {
    STORAGE_CONTAINER_NAME_RAW     = local.container_name_raw
    STORAGE_CONTAINER_NAME_CURATED = local.container_name_curated
    AZURE_OPENAI_ENDPOINT          = module.open_ai.cognitive_account_endpoint
    AZURE_OPENAI_DEPLOYMENT_NAME   = "gpt-4"
    AZURE_BLOB_STORAGE_ENDPOINT    = module.storage_account.storage_account_primary_blob_endpoint
    WORKFLOWS_SUBSCRIPTION_ID      = data.azurerm_subscription.current.subscription_id
    WORKFLOWS_RESOURCE_GROUP_NAME  = azurerm_resource_group.orchestration.name
    WORKFLOWS_LOCATION_NAME        = local.location
  }
  logic_app_always_on                                = true
  logic_app_code_path                                = "${path.module}/../../utilities/logicApp"
  logic_app_storage_account_id                       = module.storage_account_orchestration.storage_account_id
  logic_app_share_name                               = local.logic_app_name
  logic_app_key_vault_id                             = module.key_vault_orchestration.key_vault_id
  logic_app_sku                                      = "WS1"
  logic_app_application_insights_instrumentation_key = module.application_insights_orchestration.application_insights_instrumentation_key
  logic_app_application_insights_connection_string   = module.application_insights_orchestration.application_insights_connection_string
  logic_app_api_connections = {
    conversionservice = {
      kind         = "V2"
      display_name = "Content Conversion"
      description  = "A service that allows content to be converted from one format to another."
      icon_uri     = "https://connectoricons-prod.azureedge.net/releases/v1.0.1677/1.0.1677.3637"
      brand_color  = "#4f6bed"
      category     = "Standard"
    }
  }
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
  customer_managed_key       = null
}

module "data_factory_orchestration" {
  source = "./modules/datafactory"

  adf_service_name               = local.adf_service_name_orchestration
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
    keyvault_endpoint            = module.key_vault_orchestration.key_vault_uri
    storage_blob_endpoint        = module.storage_account.storage_account_primary_blob_endpoint
  }
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
  customer_managed_key       = null
}

# Role assignments logic app
resource "azurerm_role_assignment" "logic_app_role_assignment_storage_blob_data_owner" {
  description          = "Role Assignment for Data Factory to read and write data"
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_open_ai" {
  description          = "Role Assignment for Data Factory to interact with Open AI models"
  scope                = module.open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_videoindexer" {
  description          = "Role Assignment for Data Factory to interact with Video Indexer"
  scope                = module.videoindexer.videoindexer_id
  role_definition_name = "Contributor"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

# Role assignments data factory
resource "azurerm_role_assignment" "data_factory_role_assignment_storage_blob_data_owner" {
  description          = "Role Assignment for Data Factory to read and write data"
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = module.data_factory_orchestration.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_open_ai" {
  description          = "Role Assignment for Data Factory to interact with Open AI models"
  scope                = module.open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.data_factory_orchestration.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_key_vault_secrets_officer" {
  description          = "Role Assignment for Data Factory to interact with key vault"
  scope                = module.key_vault_orchestration.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = module.data_factory_orchestration.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "data_factory_role_assignment_videoindexer" {
  description          = "Role Assignment for Data Factory to interact with Video Indexer"
  scope                = module.videoindexer.videoindexer_id
  role_definition_name = "Contributor"
  principal_id         = module.data_factory_orchestration.data_factory_principal_id
  principal_type       = "ServicePrincipal"
}
