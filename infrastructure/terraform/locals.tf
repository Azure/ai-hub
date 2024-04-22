locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  ingestion_rg = "${lower(var.prefix)}-${var.environment}-${var.ingestion_rg_suffix}"

  subnet = var.subnet_id == "" ? {} : {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }
}