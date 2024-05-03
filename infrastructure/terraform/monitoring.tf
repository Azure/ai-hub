module "azure_log_analytics" {
  source = "./modules/loganalytics"

  location                        = local.location
  resource_group_name             = azurerm_resource_group.monitoring.name
  tags                            = var.tags
  log_analytics_name              = local.log_analytics_name
  log_analytics_retention_in_days = 30
}
