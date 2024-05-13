locals {
  # General
  prefix   = "${lower(var.prefix)}-${var.environment}"
  location = var.location

  # Resource names orchestration
  orchestration_rg                           = "${local.prefix}-orchstrtn"
  key_vault_name_orchestration               = "${local.prefix}-orch-kv"
  storage_account_name_orchestration_cleaned = replace("${local.prefix}-orch-stg}", "/[^a-z0-9]/", "")
  storage_account_name_orchestration         = lower(substr(local.storage_account_name_orchestration_cleaned, 0, min(length(local.storage_account_name_orchestration_cleaned), 24)))
  logic_app_name                             = "${local.prefix}-orch-logic"

  # Resource names ai
  ai_rg                 = "${local.prefix}-ai"
  videoindexer_name     = "${local.prefix}-vi"
  open_ai_name          = "${local.prefix}-aoai"
  gpt_model_name        = lower(var.model_name)
  gpt_model_version     = var.model_version
  search_service_name   = lower(replace("${local.prefix}-search", "/[^a-z0-9]/", ""))
  docintel_service_name = "${local.prefix}-docintel"

  # Resource names storage
  storage_rg                   = "${local.prefix}-strg"
  cleaned_storage_account_name = replace("${local.prefix}-stg}", "/[^a-z0-9]/", "")
  storage_account_name         = lower(substr(local.cleaned_storage_account_name, 0, min(length(local.cleaned_storage_account_name), 24)))
  container_name_shortclip     = "shortclip-results"
  container_name_upload_news   = "videos-upload-news"
  container_name_upload_movies = "videos-upload-movies"
  container_name_raw           = "videos-raw"
  container_name_curated       = "videos-curated"

  # Resource names monitoring
  monitoring_rg             = "${local.prefix}-mntrng"
  log_analytics_name        = "${local.prefix}-law"
  application_insights_name = "${local.prefix}-appi"

  # Resource names - short clip
  shortclip_rg                           = "${local.prefix}-shrtclp"
  storage_account_name_shortclip_cleaned = replace("${local.prefix}-shrtclp-stg}", "/[^a-z0-9]/", "")
  storage_account_name_shortclip         = lower(substr(local.storage_account_name_shortclip_cleaned, 0, min(length(local.storage_account_name_shortclip_cleaned), 24)))
  key_vault_name_shortclip               = "${local.prefix}-shrtclp-kv"
  function_name_shortclip                = "${local.prefix}-shrtclp-fnctn"
  user_assigned_identity_name_shortclip  = "${local.prefix}-shrtclp-uai"
  function_sku_cpu_count = {
    EP1 = "1"
    EP2 = "2"
    EP3 = "4"
  }

  # Network
  subnet = var.subnet_id == "" ? {} : {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }

  # File references
  logic_app_orchestration_code_path = "${path.module}/../../utilities/logicApp"
  function_shortclip_code_path      = "${path.module}/modules/functions/rag-video-tagging/code/durablefunction"
  meta_prompt_code_path             = "${path.module}/../../utilities/AssistantMetaPrompt.txt"
  newstagextraction_system_prompt   = "${path.module}/../../utilities/NewstagextractionSystemPrompt.txt"
  newstagextraction_user_prompt     = "${path.module}/../../utilities/NewstagextractionUserPrompt.txt"
}
