locals {
  # General
  prefix   = "${lower(var.prefix)}-${var.environment}"
  location = var.location

  # Resource names
  ingestion_rg                          = "${local.prefix}-ingestion"
  observability_rg                      = "${local.prefix}-observability"
  processing_rg                         = "${local.prefix}-processing"
  cleaned_storage_account_name          = replace("${local.prefix}-stg}", "/[^a-z0-9]/", "")
  storage_account_name                  = lower(substr(local.cleaned_storage_account_name, 0, min(length(local.cleaned_storage_account_name), 24)))
  azure_managed_identity_name           = "${local.prefix}-uai"
  log_analytics_name                    = "${local.prefix}-law"
  application_insights_name             = "${local.prefix}-appi"
  azure_key_vault_name                  = "${local.prefix}-kv"
  videoindexer_name                     = "${local.prefix}-vi"
  azure_open_ai_name                    = "${local.prefix}-aoai"
  azure_search_service_name             = lower(replace("${local.prefix}-search", "/[^a-z0-9]/", ""))
  docintel_service_name                 = "${local.prefix}-docintel"
  adf_service_name                      = "${local.prefix}-adf"
  function_name                         = "${local.prefix}-func"
  function_service_plan_name            = "${local.prefix}-func"
  cleaned_function_storage_account_name = replace("${local.function_name}}", "/[^a-z0-9]/", "")
  function_storage_account_name         = lower(substr(local.cleaned_function_storage_account_name, 0, min(length(local.cleaned_function_storage_account_name), 22)))
  azure_function_name_helloworld        = "${local.function_name}-helloworld"
  azure_function_name_shortclip         = "${local.function_name}-shortclip"
  azure_function_name_assistant         = "${local.function_name}-assistant"

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
      value = module.azure_open_ai.azurerm_cognitive_account_endpoint
    },
    storageaccounturl = {
      type  = "String"
      value = module.azure_storage_account.storage_account_primary_blob_endpoint
    }
  }
  data_factory_github_repo       = {}
  data_factory_azure_devops_repo = {}
}
