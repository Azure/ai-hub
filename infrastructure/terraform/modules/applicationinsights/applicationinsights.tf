resource "azurerm_application_insights" "application_insights" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  workspace_id     = var.log_analytics_workspace_id
  application_type = "web"
}
