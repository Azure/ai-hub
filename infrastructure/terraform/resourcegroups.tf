# resource "azurerm_resource_group" "ingestion" {
#   name     = local.ingestion_rg
#   location = local.location
# }

# New resource groups
resource "azurerm_resource_group" "orchestration" {
  name     = local.orchestration_rg
  location = local.location
}

resource "azurerm_resource_group" "monitoring" {
  name     = local.monitoring_rg
  location = local.location
}

resource "azurerm_resource_group" "storage" {
  name     = local.storage_rg
  location = local.location
}

resource "azurerm_resource_group" "ai" {
  name     = local.ai_rg
  location = local.location
}

resource "azurerm_resource_group" "shortclip" {
  name     = local.shortclip_rg
  location = local.location
}

resource "azurerm_resource_group" "assisstant" {
  name     = local.assisstant_rg
  location = local.location
}
