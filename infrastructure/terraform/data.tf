data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "local_file" "file_meta_prompt" {
  filename = local.meta_prompt_code_path
}

data "local_file" "file_newstagextraction_system_prompt" {
  filename = local.newstagextraction_system_prompt
}

data "local_file" "file_newstagextraction_user_prompt" {
  filename = local.newstagextraction_user_prompt
}
