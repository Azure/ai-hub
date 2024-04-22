locals {

  prefix = "${lower(var.prefix)}-${var.environment}"
  location = var.location

  ingestion_rg = "${local.prefix}-${var.ingestion_rg_suffix}"
  observability_rg = "${local.prefix}-${var.observability_rg_suffix}"

  azure_managed_identity_name = "${local.prefix}-uai"

  subnet = var.subnet_id == "" ? {} : {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }
}