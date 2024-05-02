module "storage_account" {
  source = "./modules/storageaccount"

  location             = local.location
  resource_group_name  = azurerm_resource_group.storage.name
  tags                 = var.tags
  storage_account_name = local.storage_account_name
  storage_account_container_names = [
    local.container_name_shortclip,
    local.container_name_raw,
    local.container_name_curated
  ]
  storage_account_share_names               = []
  storage_account_shared_access_key_enabled = true
  log_analytics_workspace_id                = module.azure_log_analytics.log_analytics_id
  subnet_id                                 = var.subnet_id
  customer_managed_key                      = null
}
