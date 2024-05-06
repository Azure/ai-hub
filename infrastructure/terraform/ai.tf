module "open_ai" {
  source = "./modules/aoai"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.ai.name
  tags                       = var.tags
  cognitive_service_name     = local.open_ai_name
  cognitive_service_kind     = "OpenAI"
  cognitive_service_sku      = "S0"
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
  customer_managed_key       = null
  gpt_model_name             = local.gpt_model_name
  gpt_model_version          = local.gpt_model_version

}

module "videoindexer" {
  source = "./modules/videoindexer"

  videoindexer_name          = local.videoindexer_name
  resource_group_name        = azurerm_resource_group.ai.name
  location                   = local.location
  storage_account_id         = module.storage_account_video_indexer.storage_account_id
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
}
