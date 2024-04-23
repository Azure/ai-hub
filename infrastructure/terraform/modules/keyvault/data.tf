data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_key_vault" {
  resource_id = azurerm_key_vault.key_vault.id
}

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = local.cmk_uai.name
  resource_group_name = local.cmk_uai.resource_group_name
}