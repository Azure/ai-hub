module "azure_open_ai" {
  source = "./modules/aoai"
  location                              = var.location
  resource_group_name                   = azurerm_resource_group.azureVideoWorkload_rg.name
  cognitive_service_name                = var.cognitive_service_name
  cognitive_service_kind                = "OpenAI"
  cognitive_service_sku                 = "S0"
  log_analytics_workspace_id            = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                            = module.azure_managed_identity.user_assigned_identity_id
  cmk_key_vault_id                      = module.azure_key_vault.key_vault_id
  cmk_key_name                          = module.azure_key_vault.key_vault_cmk_name
  key_vault_uri                         = module.azure_key_vault.key_vault_uri
  subnet_id                             = var.subnet_id
}

module "azure_storage_account" {
  source = "./modules/storageaccount"
  location                              = var.location
  resource_group_name                   = azurerm_resource_group.azureVideoWorkload_rg.name
  log_analytics_workspace_id            = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                            = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                             = var.subnet_id
  storage_account_name                  = var.storage_account_name
  cmk_key_vault_id                      = module.azure_key_vault.key_vault_id
  cmk_key_name                          = module.azure_key_vault.key_vault_key_storage_name
  depends_on = [ module.azure_key_vault ]
  
}

module "azure_log_analytics" {
    source                              = "./modules/loganalytics"
    location                            = var.location
    log_analytics_name                  = var.log_analytics_name
    log_analytics_sku                   = var.log_analytics_sku
    log_analytics_retention_in_days     = 30
    log_analytics_resource_group_name   = azurerm_resource_group.observability_rg.name
}

module "azure_key_vault" {
  source                                = "./modules/keyvault"
  key_vault_name                        = var.key_vault_name
  location                              = var.location
  resource_group_name                   = azurerm_resource_group.azureVideoWorkload_rg.name
  key_vault_sku_name                    = var.key_vault_sku
  log_analytics_workspace_id            = module.azure_log_analytics.log_analytics_id
  cmk_uai_id                            = module.azure_managed_identity.user_assigned_identity_id
  subnet_id                             = var.subnet_id
}

module "azure_managed_identity" {
  source                                = "./modules/managedidentity"
  location                              = var.location
  resource_group_name                   = azurerm_resource_group.azureVideoWorkload_rg.name
  user_assigned_identity_name           = var.user_assigned_identity_name
}

module "azure_search_service" {
  source = "./modules/aisearch"
  location = var.location
  resource_group_name = azurerm_resource_group.azureVideoWorkload_rg.name
  search_service_name = var.search_service_name
  sku = "standard"
  partition_count = var.partition_count
  replica_count = var.replica_count
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  cmk_uai_id = module.azure_managed_identity.user_assigned_identity_id
  cmk_key_vault_id = module.azure_key_vault.key_vault_id
  subnet_id = var.subnet_id
  cmk_key_name = module.azure_key_vault.key_vault_cmk_name
}

module "data_factory" {
  source = "./modules/datafactory"
  location = var.location
  resource_group_name = azurerm_resource_group.azureVideoWorkload_rg.name
  adf_service_name = var.adf_service_name
  sku = "Standard"
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id = var.subnet_id
}

module "document_intelligence" {
  source = "./modules/documentintel"
  location = var.location
  resource_group_name = azurerm_resource_group.azureVideoWorkload_rg.name
  docintel_service_name = var.docintel_service_name
}

module "video_indexer" {
  source = "./modules/videoindexer"
  vi_service_name = var.vi_service_name
  location = var.location
  resource_group_name = azurerm_resource_group.azureVideoWorkload_rg.name
  prefix = var.prefix
  videoSystemIdentity = var.videoSystemIdentity
  videoMonCreation = var.videoMonCreation
}