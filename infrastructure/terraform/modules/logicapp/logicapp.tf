resource "azurerm_logic_app_standard" "logic_app_standard" {
  name                = var.logic_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  app_service_plan_id        = azurerm_service_plan.service_plan.id
  app_settings               = local.logic_app_application_settings
  bundle_version             = "[1.*, 2.0.0)"
  client_affinity_enabled    = false
  client_certificate_mode    = "Required"
  enabled                    = true
  https_only                 = true
  storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
  storage_account_name       = data.azurerm_storage_account.storage_account.name
  storage_account_share_name = var.logic_app_share_name
  use_extension_bundle       = true
  version                    = "~4"
  virtual_network_subnet_id  = null # Change for prod
  site_config {
    always_on       = var.logic_app_always_on
    app_scale_limit = 0
    # cors {
    #   allowed_origins = []
    #   support_credentials = false
    # }
    # health_check_path = ""
    dotnet_framework_version         = "v6.0"
    elastic_instance_minimum         = 1 # Update to '3' for production
    ftps_state                       = "Disabled"
    http2_enabled                    = true
    ip_restriction                   = []
    min_tls_version                  = "1.2"
    pre_warmed_instance_count        = 1
    runtime_scale_monitoring_enabled = true
    scm_ip_restriction               = []
    scm_min_tls_version              = "1.2"
    scm_type                         = "None"
    scm_use_main_ip_restriction      = false
    use_32_bit_worker_process        = false
    vnet_route_all_enabled           = false # Change for prod
    websockets_enabled               = false
  }
}
