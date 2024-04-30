data "azurerm_client_config" "current" {}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_linux_function_app" {
  resource_id = azurerm_linux_function_app.linux_function_app.id
}

data "azurerm_function_app_host_keys" "function_app_host_keys" {
  name                = azurerm_linux_function_app.linux_function_app.name
  resource_group_name = azurerm_linux_function_app.linux_function_app.resource_group_name

  depends_on = [
    azurerm_linux_function_app.linux_function_app
  ]
}

data "azurerm_storage_account" "storage_account" {
  name                = local.storage_account.name
  resource_group_name = local.storage_account.resource_group_name
}

data "azurerm_key_vault" "key_vault" {
  name                = local.key_vault.name
  resource_group_name = local.key_vault.resource_group_name
}

data "archive_file" "file_function" {
  count = var.function_code_path != "" ? 1 : 0

  type        = "zip"
  source_dir  = var.function_code_path
  output_path = "${path.module}/${format("function-${var.function_name}-%s.zip", formatdate("YYYY-MM-DD'-'hh_mm_ss", timestamp()))}"
}
