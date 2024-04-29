data "azurerm_function_app_host_keys" "function_app_host_keys_shortclip" {
  name = azurerm_linux_function_app.shortclip_function.name
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_linux_function_app.shortclip_function
  ]
}

data "azurerm_function_app_host_keys" "function_app_host_keys_assistant" {
  name = azurerm_linux_function_app.assistant_function.name
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_linux_function_app.assistant_function
  ]
}

data "archive_file" "helloworld" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/fastapi-on-azure-functions/.funcignore"))
  source_dir  = "${path.module}/fastapi-on-azure-functions"
  output_path = "${path.module}/${format("helloworld-%s.zip", formatdate("YYYY-MM-DD'-'hh_mm_ss", timestamp()))}"
}

data "archive_file" "shortclip" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/rag-video-tagging/code/durablefunction/.funcignore"))
  source_dir  = "${path.module}/rag-video-tagging/code/durablefunction"
  output_path = "${path.module}/${format("shortlcip-%s.zip", formatdate("YYYY-MM-DD'-'hh_mm_ss", timestamp()))}"
}

data "archive_file" "assistant" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/functionassistant/.funcignore"))
  source_dir  = "${path.module}/functionassistant"
  output_path = "${path.module}/${format("assistant-%s.zip", formatdate("YYYY-MM-DD'-'hh_mm_ss", timestamp()))}"
}

data "azurerm_storage_account" "functions_storage" {
  name                = lower(element(split("/", var.functions_storage_account_id), 8))
  resource_group_name = lower(element(split("/", var.functions_storage_account_id), 4))
}

data "azurerm_storage_account" "video_storage" {
  name                = lower(element(split("/", var.video_storage_account_id), 8))
  resource_group_name = lower(element(split("/", var.video_storage_account_id), 4))
}

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = lower(element(split("/", var.user_assigned_identity_id), 8))
  resource_group_name = lower(element(split("/", var.user_assigned_identity_id), 4))
}
