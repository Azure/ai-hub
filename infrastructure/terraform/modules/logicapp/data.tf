data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_logic_app" {
  resource_id = azurerm_logic_app_standard.logic_app_standard.id
}

data "azurerm_storage_account" "storage_account" {
  name                = local.storage_account.name
  resource_group_name = local.storage_account.resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = local.key_vault.name
  resource_group_name = local.key_vault.resource_group_name
}

data "archive_file" "file_logic_app" {
  count = var.logic_app_code_path != "" ? 1 : 0

  type        = "zip"
  source_dir  = var.logic_app_code_path
  output_path = "${path.module}/${format("logicapp-${var.logic_app_name}-%s.zip", formatdate("YYYY-MM-DD'-'hh_mm_ss", timestamp()))}"
}
