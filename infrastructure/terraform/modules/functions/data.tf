data "archive_file" "function" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/fastapi-on-azure-functions/.funcignore"))
  source_dir  = "${path.module}/fastapi-on-azure-functions"
  output_path = "${path.module}/fastapi.zip"
}

data "archive_file" "rag_video_tagging" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/rag-video-tagging/code/durablefunction/.funcignore"))
  source_dir  = "${path.module}/rag-video-tagging/code/durablefunction"
  output_path = "${path.module}/rag.zip"
}

data "archive_file" "assistant" {
  type        = "zip"
  excludes    = split("\n", file("${path.module}/functionassistant/.funcignore"))
  source_dir  = "${path.module}/functionassistant"
  output_path = "${path.module}/functionassistant.zip"
}

data "azurerm_storage_account" "functions_storage" {
  name = lower(element(split("/", var.functions_storage_account_id), 8))
  resource_group_name = lower(element(split("/", var.functions_storage_account_id), 4))
}

data "azurerm_storage_account" "video_storage" {
  name = lower(element(split("/", var.video_storage_account_id), 8))
  resource_group_name = lower(element(split("/", var.video_storage_account_id), 4))
}

data "azurerm_cognitive_account" "cognitive_service" {
  name = lower(element(split("/", var.cognitive_service_id), 8))
  resource_group_name = lower(element(split("/", var.cognitive_service_id), 4))
}
