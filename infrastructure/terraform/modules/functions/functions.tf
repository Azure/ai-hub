resource "azurerm_service_plan" "service_plan" {
  name                = var.function_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # maximum_elastic_worker_count = 20
  os_type                  = "Linux"
  per_site_scaling_enabled = false
  sku_name                 = var.function_sku
  worker_count             = 1     # Update to '3' for production
  zone_balancing_enabled   = false # Update to 'true' for production
}

resource "azurerm_linux_function_app" "assistant_function" {
  name                          = var.assistant_function_service_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  storage_account_name          = data.azurerm_storage_account.functions_storage.name
  service_plan_id               = azurerm_service_plan.service_plan.id
  storage_uses_managed_identity = true
  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  zip_deploy_file = data.archive_file.rag_video_tagging.output_path
}

resource "azurerm_linux_function_app" "shortclip_function" {
  name                          = var.shortclip_function_service_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  storage_account_name          = data.azurerm_storage_account.functions_storage.name
  service_plan_id               = azurerm_service_plan.service_plan.id
  storage_uses_managed_identity = true
  identity {
    type = "SystemAssigned"
  }
  app_settings = {
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    STORAGE_DOMAIN_NAME            = replace(trimprefix(data.azurerm_storage_account.video_storage.primary_blob_endpoint, "https://"),"/","")
    STORAGE_CONTAINER_NAME         = "video"
    AZURE_OPEN_AI_API_VERSION      = "2024-02-15-preview"
    AZURE_OPEN_AI_DEPLOYMENT_NAME  = "gpt-4"
    TaskHubName                    = "shortclip"
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    AZURE_OPEN_AI_BASE_URL         = data.azurerm_cognitive_account.cognitive_service.endpoint
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  zip_deploy_file = data.archive_file.rag_video_tagging.output_path
}

# Assiging RBAC to underlying Storage Account for the function apps
resource "azurerm_role_assignment" "storage_account_owner_assistant" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
}
resource "azurerm_role_assignment" "storage_account_owner_shortclip" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
}

# Assiging RBAC to Storage Account containing videos to download and upload 
resource "azurerm_role_assignment" "video_storage_account_owner_assistant" {
  scope                = data.azurerm_storage_account.video_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
}

resource "azurerm_role_assignment" "video_storage_account_owner_shortclip" {
  scope                = data.azurerm_storage_account.video_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
}


# Assiging RBAC to OpenAI Account for functions to call the Assistnat APIs
resource "azurerm_role_assignment" "aoai_cognitive_service_owner_assistant" {
  scope                = data.azurerm_cognitive_account.cognitive_service.id
  role_definition_name = "Cognitive Services Contributor"
  principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
}

resource "azurerm_role_assignment" "aoai_cognitive_service_owner_shortclip" {
  scope                = data.azurerm_cognitive_account.cognitive_service.id
  role_definition_name = "Cognitive Services Contributor"
  principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
}