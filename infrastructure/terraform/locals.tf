locals {

  prefix = "${lower(var.prefix)}-${var.environment}"
  location = var.location

  ingestion_rg = "${local.prefix}-${var.ingestion_rg_suffix}"
  observability_rg = "${local.prefix}-${var.observability_rg_suffix}"

  cleaned_storage_account_name = replace("${local.prefix}-storage}", "/[^a-z0-9]/", "")
  storage_account_name = lower(substr(local.cleaned_storage_account_name, 0, min(length(local.cleaned_storage_account_name), 24)))

  azure_managed_identity_name = "${local.prefix}-uai"
  azure_key_vault_name = "${local.prefix}-kv"
  videoindexer_name = "${local.prefix}-videoindexer"
  azure_open_ai_name = "${local.prefix}-aoai"

  subnet = var.subnet_id == "" ? {} : {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }
}