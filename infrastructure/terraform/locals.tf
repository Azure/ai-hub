locals {
  # General
  prefix   = "${lower(var.prefix)}-${var.environment}"
  location = var.location

  # Resource names orchestration
  orchestration_rg                           = "${local.prefix}-orchstrtn"
  adf_service_name_orchestration             = "${local.prefix}-orch-adf"
  key_vault_name_orchestration               = "${local.prefix}-orch-kv"
  storage_account_name_orchestration_cleaned = replace("${local.prefix}-orch-stg}", "/[^a-z0-9]/", "")
  storage_account_name_orchestration         = lower(substr(local.storage_account_name_orchestration_cleaned, 0, min(length(local.storage_account_name_orchestration_cleaned), 24)))
  application_insights_name                  = "${local.prefix}-orch-appi"
  logic_app_name                             = "${local.prefix}-orch-logic"

  # Resource names ai
  ai_rg                 = "${local.prefix}-ai"
  videoindexer_name     = "${local.prefix}-vi"
  open_ai_name          = "${local.prefix}-aoai"
  search_service_name   = lower(replace("${local.prefix}-search", "/[^a-z0-9]/", ""))
  docintel_service_name = "${local.prefix}-docintel"

  # Resource names storage
  storage_rg                   = "${local.prefix}-strg"
  cleaned_storage_account_name = replace("${local.prefix}-stg}", "/[^a-z0-9]/", "")
  storage_account_name         = lower(substr(local.cleaned_storage_account_name, 0, min(length(local.cleaned_storage_account_name), 24)))
  container_name_shortclip     = "shortclip-results"
  container_name_raw           = "videos-raw"
  container_name_curated       = "videos-curated"

  # Resource names monitoring
  monitoring_rg      = "${local.prefix}-mntrng"
  log_analytics_name = "${local.prefix}-law"

  # Resource names - short clip
  shortclip_rg                           = "${local.prefix}-shrtclp"
  storage_account_name_shortclip_cleaned = replace("${local.prefix}-shrtclp-stg}", "/[^a-z0-9]/", "")
  storage_account_name_shortclip         = lower(substr(local.storage_account_name_shortclip_cleaned, 0, min(length(local.storage_account_name_shortclip_cleaned), 24)))
  key_vault_name_shortclip               = "${local.prefix}-shrtclp-kv"
  application_insights_name_shortclip    = "${local.prefix}-shrtclp-appi"
  function_name_shortclip                = "${local.prefix}-shrtclp-fnctn"
  user_assigned_identity_name_shortclip  = "${local.prefix}-shrtclp-uai"

  # Resource names - assisstant
  assisstant_rg                           = "${local.prefix}-assisstant"
  storage_account_name_assisstant_cleaned = replace("${local.prefix}-assisst-stg}", "/[^a-z0-9]/", "")
  storage_account_name_assisstant         = lower(substr(local.storage_account_name_assisstant_cleaned, 0, min(length(local.storage_account_name_assisstant_cleaned), 24)))
  key_vault_name_assisstant               = "${local.prefix}-assisst-kv"
  application_insights_name_assisstant    = "${local.prefix}-assisst-appi"
  function_name_assisstant                = "${local.prefix}-assisst-fnctn"
  user_assigned_identity_name_assisstant  = "${local.prefix}-assisst-uai"

  # Network
  subnet = var.subnet_id == "" ? {} : {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }

  # Data Factory 
  data_factory_global_parameters_default = {
    openai_api_base = {
      type  = "String"
      value = module.open_ai.azurerm_cognitive_account_endpoint
    },
    storageaccounturl = {
      type  = "String"
      value = module.storage_account.storage_account_primary_blob_endpoint
    }
  }
  data_factory_github_repo       = {}
  data_factory_azure_devops_repo = {}
}
