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

resource "azurerm_storage_container" "videos_in" {
  name                  = "videosin"
  storage_account_name  =  data.azurerm_storage_account.video_storage.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "assistant" {
  name                  = "videossassistant"
  storage_account_name  =  data.azurerm_storage_account.video_storage.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "videos_out" {
  name                  = "videosout"
  storage_account_name  =  data.azurerm_storage_account.video_storage.name
  container_access_type = "private"
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
    APPINSIGHTS_INSTRUMENTATIONKEY = var.instrumentation_key
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    STORAGE_DOMAIN_NAME            = replace(trimprefix(data.azurerm_storage_account.video_storage.primary_blob_endpoint, "https://"), "/", "")
    STORAGE_CONTAINER_NAME         = "video"
    # storage_account_name           = data.azurerm_storage_account.functions_storage.name
    # WEBSITE_CONTENTSHARE           = "assistantfunction9956"
    TaskHubName                    = "assistant"
    categories                     = "{[\"documentary\",\"football_talkshow\"]}"
    documentary                    = "Your task is to extract scenes from a political documentary that are suitable for making short videos. You have identify the scenes that are more impactful.   Here are the steps you should follow: ------- 1. Process all the scenes in the video to understand the context. 2. Process each scene to find the ones that can be used to generate a short video. 3. Assign a rating to the scene between 1 to 10, being 1 the scene that better describes the video, while 10 would be the scene that does not add much value (for example, rolling credits).   input: Your input will be a structured array containing one or more scenes. Each scene will have the following structure:     -id : scene id     -start: start time of the scene     -end: end time of the scene     -content: content of the section. You have to deep inspect the text here to find the suitable clips.             This is a single string however it will have multiple tags in square brackets.             You have to find the suitable clip based on the content and tags.             [Video title] will be the title of the video             [Tags]  will be the tags of the video             [Detected Objects]  will be the objects detected in the video             [OCR] will be the text detected in the video             [Known people]  will be the known people in the video             [Transcript] will be the transcript of the scene   You have to combine all the information present in the content using all the different tags and then find the suitable scenes.   {     \"summary\": \"This is the summary of the whole video\",     \"scenes\": [         {             \"id\": \"scene id\",             \"title\": \"short title of the scene based on summary\",             \"rating\": 10,             \"reasoning\": \"This scene is suitable for making short videos that can go viral on social media because...\",             \"description\": \"brief description of what this scene is about\",             \"start_time\": \"start time of the scene\",             \"end_time\": \"end time of the scene\",             \"transcript\": \"This is the transcript of the scene\",             \"translation\": \"Translation of the transcript to English\"         }     ] }   - Your output must be in strict JSON format. Don't include any comments or other characters that are not part of the JSON format. - You must proceed with the full analysis and summarization to populate the JSON file with accurate data. - Use the following format for start time and end time of the scenes: dd:hh:mm:ss. - Do not translate the output to English. Keep the output on the same language as the languages used in the source transcript. - You identify only the top 5 scenes based on the ratings. - you have to provide reasoning for the rating."
    football_talkshow              = "Your task is to extract scenes from a sports TV show that are suitable for making short videos. You have identify the scenes that are more impactful, by identifying scenes or keywords with topics like \"intense discussion\", \"crucial point\", \"well-known guest\", \"dramatic\". You have to process each scene to find the ones that can be used to generate a short video. Use code interpreter when analyzing the provided content. Write and execute a script to process the document, extract relevant data for each scene and create a JSON file with the name provided in the prompt. You will then provide a download link for the created file.  Output: Generate a JSON file with the following structure summarized the most relevant scenes:   {     \"summary\": \"This is the summary of the whole video\",     \"scenes\": [         {             \"id\": \"scene id\",             \"title\": \"short title of the scene based on summary\",                         \"reasoning\": \"This scene is suitable for making short videos that can go viral on social media because...\",             \"description\": \"brief description of what this scene is about\",             \"start_time\": \"start time of the scene\",             \"end_time\": \"end time of the scene\",             \"transcript\": \"This is the transcript of the scene\",             \"translation\": \"Translation of the transcript to English\"         }     ] }   - Your output must be in strict JSON format. Don't include any comments or other characters that are not part of the JSON format. - You must proceed with the full analysis and summarization to populate the JSON file with accurate data. Don't skip scenes. - Use the following format for start time and end time of the scenes: dd:hh:mm:ss. - You identify only the top 5 more relevat scenes. - you have to provide reasoning for the rating."
    metaprompt                     = "Your task is to extract scenes from a political documentary that are suitable for making short videos. You have identify the scenes that are more impactful. Here are the steps you should follow: ------- 1. Process all the scenes in the video to understand the context. 2. Process each scene to find the ones that can be used to generate a short video. 3. Assign a rating to the scene between 1 to 10, being 1 the scene that better describes the video, while 10 would be the scene that does not add much value (for example, rolling credits). input: Your input will be a structured array containing one or more scenes. Each scene will have the following structure:     -id : scene id     -start: start time of the scene     -end: end time of the scene     -content: content of the section. You have to deep inspect the text here to find the suitable clips.             This is a single string however it will have multiple tags in square brackets.             You have to find the suitable clip based on the content and tags.             [Video title] will be the title of the video             [Tags]  will be the tags of the video             [Detected Objects]  will be the objects detected in the video             [OCR] will be the text detected in the video             [Known people]  will be the known people in the video             [Transcript] will be the transcript of the scene You have to combine all the information present in the content using all the different tags and then find the suitable scenes. {     \"summary\": \"This is the summary of the whole video\",     \"scenes\": [         {             \"id\": \"scene id\",             \"title\": \"short title of the scene based on summary\",             \"rating\": 10,             \"reasoning\": \"This scene is suitable for making short videos that can go viral on social media because...\",             \"description\": \"brief description of what this scene is about\",             \"start_time\": \"start time of the scene\",             \"end_time\": \"end time of the scene\",             \"transcript\": \"This is the transcript of the scene\",             \"translation\": \"Translation of the transcript to English\"         }     ] } - Your output must be in strict JSON format. Don't include any comments or other characters that are not part of the JSON format. - You must proceed with the full analysis and summarization to populate the JSON file with accurate data. - Use the following format for start time and end time of the scenes: dd:hh:mm:ss. - Do not translate the output to English. Keep the output on the same language as the languages used in the source transcript. - You identify only the top 5 scenes based on the ratings. - you have to provide reasoning for the rating."
    azapi_resource_videoindexer_id = var.azapi_resource_videoindexer_id
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  zip_deploy_file = data.archive_file.assistant.output_path
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_function" {
  resource_id = azurerm_linux_function_app.assistant_function.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_function_assistant" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_linux_function_app.assistant_function.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
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
    APPINSIGHTS_INSTRUMENTATIONKEY = var.instrumentation_key
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    STORAGE_DOMAIN_NAME            = replace(trimprefix(data.azurerm_storage_account.video_storage.primary_blob_endpoint, "https://"), "/", "")
    STORAGE_CONTAINER_NAME         = azurerm_storage_container.videos_out.name
    AZURE_OPEN_AI_API_VERSION      = "2024-02-15-preview"
    AZURE_OPEN_AI_DEPLOYMENT_NAME  = "gpt-4"
    TaskHubName                    = "shortclip"
    AZURE_OPEN_AI_BASE_URL         = data.azurerm_cognitive_account.cognitive_service.endpoint
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  zip_deploy_file = data.archive_file.rag_video_tagging.output_path
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_function_shortclip" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_linux_function_app.shortclip_function.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}



# Assiging RBAC to underlying Storage Account for the function apps - Assistant
resource "azurerm_role_assignment" "storage_account_blob_owner_assistant" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
}
resource "azurerm_role_assignment" "storage_account_queue_contributor_assistant" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_account_table_contributor_assistant" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_linux_function_app.assistant_function.identity[0].principal_id
}


# Assiging RBAC to underlying Storage Account for the function apps - Shortlcip
resource "azurerm_role_assignment" "storage_account_blob_owner_shortclip" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_account_queue_contributor_shortclip" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
}

resource "azurerm_role_assignment" "storage_account_table_contributor_shortclip" {
  scope                = data.azurerm_storage_account.functions_storage.id
  role_definition_name = "Storage Table Data Contributor"
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

resource "azurerm_role_assignment" "aoai_cognitive_service_openai_user_shortclip" {
  scope                = data.azurerm_cognitive_account.cognitive_service.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_linux_function_app.shortclip_function.identity[0].principal_id
}
