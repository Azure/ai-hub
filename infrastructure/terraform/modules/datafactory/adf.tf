
resource "azurerm_data_factory" "data_factory" {
  name                = var.adf_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
identity {
    type = "SystemAssigned"
  }
} 

resource "azurerm_data_factory_pipeline" "Document" {
  name            = "Document"
  data_factory_id = azurerm_data_factory.data_factory.id
  parameters = {
        "fileName" = "layout.png",
        "gpt4_deployment_name" = "gpt-4",
        "openai_api_base" = "https://esp1-swedencentral-azopenai.openai.azure.com/" 
        "cosmosaccount" = "https://esp1-swedencentral-cosmosdb.documents.azure.com:443/",
        "cosmoscontainer"= "docs",
        "cosmosdb" = "responses",
        "storageaccounturl" = "https://useme.blob.core.windows.net/",
        "storageAccountContainer" = "docsin",
        "temperature" = "1",
        "top_p" = "1",
        "searchServiceEndpoint" = "https://esp1-swedencentral-azaisearch.search.windows.net",
        "indexName" = "esp1test",
        "embeddingDeploymentName"  = "embedding",
        "sys_message" = "You are an AI assistant that helps people find information.",
        "user_prompt" = "Summarize the data for me.",
        "storageAccountResourceId" = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/esp1-rg-swedencentral/providers/Microsoft.Storage/storageAccounts/useme",
        "documentIntelligenceAPI" = "https://esp1-westeurope-docintel.cognitiveservices.azure.com/",
        "modelId" = "prebuilt-layout",
        "aiSearchIndexName" = "esp1test",
        "openAIAPI" = "https://esp1-swedencentral-azopenai.openai.azure.com/"  

    }

  activities_json = <<JSON
[

]
  JSON
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_data_factory" {
  resource_id = azurerm_data_factory.data_factory.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_data_factory" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_data_factory.data_factory.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}