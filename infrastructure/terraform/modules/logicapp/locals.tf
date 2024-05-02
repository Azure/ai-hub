locals {
  logic_app_application_settings_default = {
    FUNCTIONS_WORKER_RUNTIME     = "node"
    WEBSITE_NODE_DEFAULT_VERSION = "~18"
    # WEBSITE_RUN_FROM_PACKAGE     = "1"
  }
  logic_app_application_settings_connection_runtime_urls = {
    for key, value in azapi_resource.api_connection_arm:
    "${title(key)}ConnectionRuntimeUrl" => jsondecode(value.output).properties.connectionRuntimeUrl
  }
  logic_app_application_settings = merge(local.logic_app_application_settings_default, local.logic_app_application_settings_connection_runtime_urls, var.logic_app_application_settings)

  storage_account = {
    resource_group_name = split("/", var.logic_app_storage_account_id)[4]
    name                = split("/", var.logic_app_storage_account_id)[8]
  }

  key_vault = {
    resource_group_name = split("/", var.logic_app_key_vault_id)[4]
    name                = split("/", var.logic_app_key_vault_id)[8]
  }
}
