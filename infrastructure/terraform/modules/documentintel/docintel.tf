resource "azurerm_cognitive_account" "document_intelligence" {
  name                = var.docintel_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  identity {
    type = "SystemAssigned"
  }

  kind     = "FormRecognizer"
  sku_name = "S0"
  tags = {
    Evironment = "Dev"
  }
}