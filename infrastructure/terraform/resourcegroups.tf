resource "azurerm_resource_group" "ingestion" {
  name     = local.ingestion_rg
  location = local.location
}

resource "azurerm_resource_group" "observability" {
  name     = local.observability_rg
  location = local.location
}

resource "azurerm_resource_group" "processing" {
  name     = local.processing_rg
  location = local.location
}
