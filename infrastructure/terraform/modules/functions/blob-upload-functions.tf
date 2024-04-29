# Upload the function code to the storage account

resource "azurerm_storage_container" "videos_in" {
  name                  = "videosin"
  storage_account_name  = data.azurerm_storage_account.video_storage.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "assistant" {
  name                  = "videossassistant"
  storage_account_name  = data.azurerm_storage_account.video_storage.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "videos_out" {
  name                  = "videosout"
  storage_account_name  = data.azurerm_storage_account.video_storage.name
  container_access_type = "private"
}


resource "azurerm_storage_container" "function_code" {
  name                  = "function-code"
  storage_account_name  = data.azurerm_storage_account.functions_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "helloworld_function_blob" {
  name                   = basename(data.archive_file.helloworld.output_path)
  storage_account_name   = data.azurerm_storage_account.functions_storage.name
  storage_container_name = azurerm_storage_container.function_code.name
  type                   = "Block"
  source                 = data.archive_file.helloworld.output_path
}


resource "azurerm_storage_blob" "assistant_function_blob" {
  name                   = basename(data.archive_file.assistant.output_path)
  storage_account_name   = data.azurerm_storage_account.functions_storage.name
  storage_container_name = azurerm_storage_container.function_code.name
  type                   = "Block"
  source                 = data.archive_file.assistant.output_path
}

resource "azurerm_storage_blob" "shortclip_function_blob" {
  name                   = basename(data.archive_file.shortclip.output_path)
  storage_account_name   = data.azurerm_storage_account.functions_storage.name
  storage_container_name = azurerm_storage_container.function_code.name
  type                   = "Block"
  source                 = data.archive_file.shortclip.output_path
}

data "azurerm_storage_account_sas" "assistant_function_blob_sas" {
  connection_string = data.azurerm_storage_account.functions_storage.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2023-03-21T00:00:00Z"
  expiry = "2025-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

output "sas_token_url_assistant_blob" {
  value = nonsensitive("${azurerm_storage_blob.assistant_function_blob.url}${data.azurerm_storage_account_sas.assistant_function_blob_sas.sas}")
}

output "sas_token_url_shortclip_blob" {
  value = nonsensitive("${azurerm_storage_blob.shortclip_function_blob.url}${data.azurerm_storage_account_sas.assistant_function_blob_sas.sas}")
}

output "sas_token_url_helloworld_blob" {
  value = nonsensitive("${azurerm_storage_blob.helloworld_function_blob.url}${data.azurerm_storage_account_sas.assistant_function_blob_sas.sas}")
}

output assistant_function_blob {
  value = basename(data.archive_file.assistant.output_path)
}