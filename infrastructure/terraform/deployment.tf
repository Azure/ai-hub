# module "application_insights" {
#   source = "./modules/applicationinsights"

#   location                   = local.location
#   resource_group_name        = azurerm_resource_group.observability.name
#   tags                       = var.tags
#   application_insights_name  = local.application_insights_name
#   log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
# }

# module "azure_managed_identity" {
#   source = "./modules/managedidentity"

#   location                    = local.location
#   resource_group_name         = azurerm_resource_group.ingestion.name
#   tags                        = var.tags
#   user_assigned_identity_name = local.azure_managed_identity_name
# }


# module "azure_storage_account_functions" {
#   source = "./modules/storageaccount"

#   location                                  = local.location
#   resource_group_name                       = azurerm_resource_group.ingestion.name
#   tags                                      = var.tags
#   storage_account_name                      = local.function_storage_account_name
#   storage_account_container_names           = []
#   storage_account_share_names               = []
#   storage_account_shared_access_key_enabled = true
#   log_analytics_workspace_id                = module.azure_log_analytics.log_analytics_id
#   subnet_id                                 = var.subnet_id
#   customer_managed_key                      = null
# }

# module "functions" {
#   source = "./modules/functions"

#   location                         = local.location
#   resource_group_name              = azurerm_resource_group.ingestion.name
#   function_service_plan_name       = local.function_service_plan_name
#   functions_storage_account_id     = module.azure_storage_account_functions.storage_account_id
#   video_storage_account_id         = module.storage_account.storage_account_id
#   function_sku                     = var.function_sku
#   helloworld_function_service_name = local.azure_function_name_helloworld
#   assistant_function_service_name  = local.azure_function_name_assistant
#   shortclip_function_service_name  = local.azure_function_name_shortclip
#   user_assigned_identity_id        = module.azure_managed_identity.user_assigned_identity_id
#   cognitive_service_id             = module.open_ai.azurerm_cognitive_account_service_id
#   cognitive_service_endpoint       = module.open_ai.azurerm_cognitive_account_endpoint
#   log_analytics_workspace_id       = module.azure_log_analytics.log_analytics_id
#   instrumentation_key              = module.application_insights.application_insights_instrumentation_key
#   app_id                           = module.application_insights.application_insights_id
#   videoindexer_account_id          = module.videoindexer.videoindexer_account_id
# }
