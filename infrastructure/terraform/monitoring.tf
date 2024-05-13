module "azure_log_analytics" {
  source = "./modules/loganalytics"

  location                        = local.location
  resource_group_name             = azurerm_resource_group.monitoring.name
  tags                            = var.tags
  log_analytics_name              = local.log_analytics_name
  log_analytics_retention_in_days = 30
}

module "application_insights" {
  source = "./modules/applicationinsights"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.monitoring.name
  tags                       = var.tags
  application_insights_name  = local.application_insights_name
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
}
