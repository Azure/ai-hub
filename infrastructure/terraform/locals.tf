locals {
  # General
  prefix   = "${lower(var.prefix)}-${var.environment}"
  location = var.location

  # Resource names
  ingestion_rg     = "${local.prefix}-${var.ingestion_rg_suffix}"
  observability_rg = "${local.prefix}-${var.observability_rg_suffix}"
  processing_rg    = "${local.prefix}-${var.processing_rg_suffix}"

  cleaned_storage_account_name = replace("${local.prefix}-storage}", "/[^a-z0-9]/", "")
  storage_account_name         = lower(substr(local.cleaned_storage_account_name, 0, min(length(local.cleaned_storage_account_name), 24)))

  azure_managed_identity_name = "${local.prefix}-${var.user_assigned_identity_name_suffix}"
  log_analytics_name          = "${local.prefix}-${var.log_analytics_name_suffix}"
  azure_key_vault_name        = "${local.prefix}-${var.key_vault_name_suffix}"
  videoindexer_name           = "${local.prefix}-${var.videoindexer_name_suffix}"
  azure_open_ai_name          = "${local.prefix}-${var.cognitive_service_name_suffix}"
  azure_search_service_name   = lower(replace("${local.prefix}-${var.search_service_name_suffix}", "/[^a-z0-9]/", ""))
  docintel_service_name       = "${local.prefix}-${var.docintel_service_name_suffix}"
  adf_service_name            = "${local.prefix}-${var.adf_service_name_suffix}"

  function_name                         = "${local.prefix}-${var.function_name_suffix}"
  function_service_plan_name            = "${local.prefix}-${var.function_name_suffix}"
  cleaned_function_storage_account_name = replace("${local.function_name}}", "/[^a-z0-9]/", "")
  function_storage_account_name         = lower(substr(local.cleaned_function_storage_account_name, 0, min(length(local.cleaned_function_storage_account_name), 22)))
  azure_function_name_helloworld        = "${local.function_name}-${var.azure_function_helloworld_service_name_suffix}"
  azure_function_name_shortclip         = "${local.function_name}-${var.azure_function_shortclip_service_name_suffix}"
  azure_function_name_assistant         = "${local.function_name}-${var.azure_function_assistant_service_name_suffix}"

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
