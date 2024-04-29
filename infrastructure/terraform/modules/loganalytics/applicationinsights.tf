resource "azurerm_application_insights" "application_insights" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags

  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type    = "web"
}
