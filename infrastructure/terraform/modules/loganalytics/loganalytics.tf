resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  allow_resource_only_permissions         = false
  cmk_for_query_forced                    = false
  immediate_data_purge_on_30_days_enabled = false
  internet_ingestion_enabled              = true
  internet_query_enabled                  = true
  local_authentication_disabled           = false
  retention_in_days                       = var.log_analytics_retention_in_days
  sku                                     = "PerGB2018"
}
