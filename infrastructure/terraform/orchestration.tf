# Resources
module "storage_account_orchestration" {
  source = "./modules/storageaccount"

  location                        = local.location
  resource_group_name             = azurerm_resource_group.orchestration.name
  tags                            = var.tags
  storage_account_name            = local.storage_account_name_orchestration
  storage_account_container_names = []
  storage_account_share_names = [
    local.logic_app_name
  ]
  storage_account_shared_access_key_enabled = true
  storage_account_hns_enabled               = false
  log_analytics_workspace_id                = module.azure_log_analytics.log_analytics_id
  subnet_id                                 = var.subnet_id
  customer_managed_key                      = null
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
    # Logic App config settings
    APPINSIGHTS_INSTRUMENTATIONKEY        = module.application_insights.application_insights_instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.application_insights.application_insights_connection_string
    WEBSITE_RUN_FROM_PACKAGE              = var.logic_app_website_run_from_package
    # App specific settings
    LOGIC_APP_ID                         = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.orchestration.name}/providers/Microsoft.Web/sites/${local.logic_app_name}"
    AZURE_BLOB_STORAGE_ENDPOINT          = module.storage_account.storage_account_primary_blob_endpoint
    STORAGE_ACCOUNT_SUBSCRIPTION_ID      = data.azurerm_subscription.current.subscription_id
    STORAGE_ACCOUNT_RESOURCE_GROUP_NAME  = module.storage_account.storage_account_resource_group_name
    STORAGE_ACCOUNT_NAME                 = module.storage_account.storage_account_name
    STORAGE_CONTAINER_NAME_UPLOAD_MOVIES = local.container_name_upload_movies
    STORAGE_CONTAINER_NAME_UPLOAD_NEWS   = local.container_name_upload_news
    STORAGE_CONTAINER_NAME_RAW           = local.container_name_raw
    STORAGE_CONTAINER_NAME_CURATED       = local.container_name_curated
    AZURE_OPENAI_ENDPOINT                = module.open_ai.cognitive_account_endpoint
    AZURE_OPENAI_DEPLOYMENT_NAME         = local.default_model_name
    VIDEO_INDEXER_ID                     = module.videoindexer.videoindexer_id
    VIDEO_INDEXER_ACCOUNT_ID             = module.videoindexer.videoindexer_account_id
    WORKFLOWS_SUBSCRIPTION_ID            = data.azurerm_subscription.current.subscription_id
    WORKFLOWS_RESOURCE_GROUP_NAME        = azurerm_resource_group.orchestration.name
    WORKFLOWS_LOCATION_NAME              = local.location
    FUNCTION_SHORTCLIP_ID                = module.function_shortclip.linux_function_app_id
    FUNCTION_SHORTCLIP_HOSTNAME          = module.function_shortclip.linux_function_app_default_hostname
    FUNCTION_SHORTCLIP_KEY               = module.function_shortclip.linux_function_app_primary_key
    META_PROMPT                          = data.local_file.file_meta_prompt.content
    DEFAULT_LANGUAGE                     = var.default_language
  }
  logic_app_always_on                                = true
  logic_app_code_path                                = "${path.module}/../../utilities/logicApp"
  logic_app_storage_account_id                       = module.storage_account_orchestration.storage_account_id
  logic_app_share_name                               = local.logic_app_name
  logic_app_key_vault_id                             = module.key_vault_orchestration.key_vault_id
  logic_app_sku                                      = var.logic_app_sku
  logic_app_application_insights_instrumentation_key = module.application_insights.application_insights_instrumentation_key
  logic_app_application_insights_connection_string   = module.application_insights.application_insights_connection_string
  logic_app_api_connections = {
    conversionservice = {
      kind                 = "V2"
      display_name         = "Content Conversion"
      description          = "A service that allows content to be converted from one format to another."
      icon_uri             = "https://connectoricons-prod.azureedge.net/releases/v1.0.1686/1.0.1686.3706"
      brand_color          = "#4f6bed"
      category             = "Standard"
      parameter_values     = {}
      parameter_value_type = null
    }
    videoindexer-v2 = {
      kind         = "V2"
      display_name = "Video Indexer (V2)"
      description  = "Easily extract insights from your videos and quickly enrich your applications to enhance discovery and engagement. Use the Video Indexer connector to turn your videos into insights."
      icon_uri     = "https://connectoricons-prod.azureedge.net/releases/v1.0.1654/1.0.1654.3410"
      brand_color  = "#127B66"
      category     = "Standard"
      parameter_values = {
        api_key = "not_required_for_arm_bsaed_authentication"
      }
      parameter_value_type = null
    }
    azureeventgrid = {
      kind                 = "V2"
      display_name         = "Azure Event Grid"
      description          = "Azure Event Grid is an eventing backplane that enables event based programing with pub/sub semantics and reliable distribution & delivery for all services in Azure as well as third parties."
      icon_uri             = "https://connectoricons-prod.azureedge.net/releases/v1.0.1680/1.0.1680.3652"
      brand_color          = "#0072c6"
      category             = "Standard"
      parameter_values     = {}
      parameter_value_type = "Alternative"
    }
  }
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
  customer_managed_key       = null
}

# Role assignments logic app
resource "azurerm_role_assignment" "logic_app_role_assignment_storage_blob_data_owner" {
  description          = "Role Assignment for Logic App to read and write data"
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_logic_apps_standard_operator" {
  description          = "Role Assignment for Logic App to dynamically fetch callback URIs"
  scope                = module.logic_app_orchestration.logic_app_id
  role_definition_name = "Logic Apps Standard Operator (Preview)"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_storage_account_contributor" {
  description          = "Role Assignment for Logic App to generate SAS tokens."
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_storage_eventgrid_eventsubscription_contributor" {
  description          = "Role Assignment for Logic App to generate SAS tokens."
  scope                = module.storage_account.storage_account_id
  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_open_ai" {
  description          = "Role Assignment for Logic App to interact with Open AI models"
  scope                = module.open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "logic_app_role_assignment_videoindexer" {
  description          = "Role Assignment for Logic App to interact with Video Indexer"
  scope                = module.videoindexer.videoindexer_id
  role_definition_name = "Contributor"
  principal_id         = module.logic_app_orchestration.logic_app_principal_id
  principal_type       = "ServicePrincipal"
}
