data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "local_file" "file_meta_prompt" {
  filename = local.meta_prompt_code_path
}
