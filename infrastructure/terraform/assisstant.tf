module "storage_account_assisstant" {
  source = "./modules/storageaccount"

  location                        = local.location
  resource_group_name             = azurerm_resource_group.assisstant.name
  tags                            = var.tags
  storage_account_name            = local.storage_account_name_assisstant
  storage_account_container_names = []
  storage_account_share_names = [
    local.function_name_assisstant
  ]
  storage_account_shared_access_key_enabled = true
  log_analytics_workspace_id                = module.azure_log_analytics.log_analytics_id
  subnet_id                                 = var.subnet_id
  customer_managed_key                      = null
}

module "application_insights_assisstant" {
  source = "./modules/applicationinsights"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.assisstant.name
  tags                       = var.tags
  application_insights_name  = local.application_insights_name_assisstant
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
}

module "key_vault_assisstant" {
  source = "./modules/keyvault"

  location                   = local.location
  resource_group_name        = azurerm_resource_group.assisstant.name
  tags                       = var.tags
  key_vault_name             = local.key_vault_name_assisstant
  key_vault_sku_name         = "premium"
  key_vault_keys             = {}
  log_analytics_workspace_id = module.azure_log_analytics.log_analytics_id
  subnet_id                  = var.subnet_id
}

module "user_assigned_identity_assisstant" {
  source = "./modules/managedidentity"

  location                    = local.location
  resource_group_name         = azurerm_resource_group.assisstant.name
  tags                        = var.tags
  user_assigned_identity_name = local.user_assigned_identity_name_assisstant
}

module "function_assisstant" {
  source = "./modules/function"

  location            = local.location
  resource_group_name = azurerm_resource_group.assisstant.name
  tags                = var.tags
  function_name       = local.function_name_assisstant
  function_application_settings = {
    # Function config settings
    BUILD_FLAGS                    = "UseExpressBuild"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    FUNCTIONS_WORKER_RUNTIME       = "python"
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    TaskHubName                    = "assisstant"
    # App specific settings
    categories              = "{[\"documentary\",\"football_talkshow\"]}"
    documentary             = "Your task is to extract scenes from a political documentary that are suitable for making short videos. You have identify the scenes that are more impactful.   Here are the steps you should follow: ------- 1. Process all the scenes in the video to understand the context. 2. Process each scene to find the ones that can be used to generate a short video. 3. Assign a rating to the scene between 1 to 10, being 1 the scene that better describes the video, while 10 would be the scene that does not add much value (for example, rolling credits).   input: Your input will be a structured array containing one or more scenes. Each scene will have the following structure:     -id : scene id     -start: start time of the scene     -end: end time of the scene     -content: content of the section. You have to deep inspect the text here to find the suitable clips.             This is a single string however it will have multiple tags in square brackets.             You have to find the suitable clip based on the content and tags.             [Video title] will be the title of the video             [Tags]  will be the tags of the video             [Detected Objects]  will be the objects detected in the video             [OCR] will be the text detected in the video             [Known people]  will be the known people in the video             [Transcript] will be the transcript of the scene   You have to combine all the information present in the content using all the different tags and then find the suitable scenes.   {     \"summary\": \"This is the summary of the whole video\",     \"scenes\": [         {             \"id\": \"scene id\",             \"title\": \"short title of the scene based on summary\",             \"rating\": 10,             \"reasoning\": \"This scene is suitable for making short videos that can go viral on social media because...\",             \"description\": \"brief description of what this scene is about\",             \"start_time\": \"start time of the scene\",             \"end_time\": \"end time of the scene\",             \"transcript\": \"This is the transcript of the scene\",             \"translation\": \"Translation of the transcript to English\"         }     ] }   - Your output must be in strict JSON format. Don't include any comments or other characters that are not part of the JSON format. - You must proceed with the full analysis and summarization to populate the JSON file with accurate data. - Use the following format for start time and end time of the scenes: dd:hh:mm:ss. - Do not translate the output to English. Keep the output on the same language as the languages used in the source transcript. - You identify only the top 5 scenes based on the ratings. - you have to provide reasoning for the rating."
    football_talkshow       = "Your task is to extract scenes from a sports TV show that are suitable for making short videos. You have identify the scenes that are more impactful, by identifying scenes or keywords with topics like \"intense discussion\", \"crucial point\", \"well-known guest\", \"dramatic\". You have to process each scene to find the ones that can be used to generate a short video. Use code interpreter when analyzing the provided content. Write and execute a script to process the document, extract relevant data for each scene and create a JSON file with the name provided in the prompt. You will then provide a download link for the created file.  Output: Generate a JSON file with the following structure summarized the most relevant scenes:   {     \"summary\": \"This is the summary of the whole video\",     \"scenes\": [         {             \"id\": \"scene id\",             \"title\": \"short title of the scene based on summary\",                         \"reasoning\": \"This scene is suitable for making short videos that can go viral on social media because...\",             \"description\": \"brief description of what this scene is about\",             \"start_time\": \"start time of the scene\",             \"end_time\": \"end time of the scene\",             \"transcript\": \"This is the transcript of the scene\",             \"translation\": \"Translation of the transcript to English\"         }     ] }   - Your output must be in strict JSON format. Don't include any comments or other characters that are not part of the JSON format. - You must proceed with the full analysis and summarization to populate the JSON file with accurate data. Don't skip scenes. - Use the following format for start time and end time of the scenes: dd:hh:mm:ss. - You identify only the top 5 more relevat scenes. - you have to provide reasoning for the rating."
    metaprompt              = "Your task is to extract scenes from a political documentary that are suitable for making short videos. You have identify the scenes that are more impactful. Here are the steps you should follow: ------- 1. Process all the scenes in the video to understand the context. 2. Process each scene to find the ones that can be used to generate a short video. 3. Assign a rating to the scene between 1 to 10, being 1 the scene that better describes the video, while 10 would be the scene that does not add much value (for example, rolling credits). input: Your input will be a structured array containing one or more scenes. Each scene will have the following structure:     -id : scene id     -start: start time of the scene     -end: end time of the scene     -content: content of the section. You have to deep inspect the text here to find the suitable clips.             This is a single string however it will have multiple tags in square brackets.             You have to find the suitable clip based on the content and tags.             [Video title] will be the title of the video             [Tags]  will be the tags of the video             [Detected Objects]  will be the objects detected in the video             [OCR] will be the text detected in the video             [Known people]  will be the known people in the video             [Transcript] will be the transcript of the scene You have to combine all the information present in the content using all the different tags and then find the suitable scenes. {     \"summary\": \"This is the summary of the whole video\",     \"scenes\": [         {             \"id\": \"scene id\",             \"title\": \"short title of the scene based on summary\",             \"rating\": 10,             \"reasoning\": \"This scene is suitable for making short videos that can go viral on social media because...\",             \"description\": \"brief description of what this scene is about\",             \"start_time\": \"start time of the scene\",             \"end_time\": \"end time of the scene\",             \"transcript\": \"This is the transcript of the scene\",             \"translation\": \"Translation of the transcript to English\"         }     ] } - Your output must be in strict JSON format. Don't include any comments or other characters that are not part of the JSON format. - You must proceed with the full analysis and summarization to populate the JSON file with accurate data. - Use the following format for start time and end time of the scenes: dd:hh:mm:ss. - Do not translate the output to English. Keep the output on the same language as the languages used in the source transcript. - You identify only the top 5 scenes based on the ratings. - you have to provide reasoning for the rating."
    videoindexer_account_id = module.videoindexer.videoindexer_account_id
  }
  function_always_on                                = false
  function_code_path                                = "${path.module}/modules/functions/functionassistant"
  function_storage_account_id                       = module.storage_account_assisstant.storage_account_id
  function_share_name                               = local.function_name_assisstant
  function_key_vault_id                             = module.key_vault_assisstant.key_vault_id
  function_user_assigned_identity_id                = module.user_assigned_identity_assisstant.user_assigned_identity_id
  function_sku                                      = "EP1"
  function_application_insights_instrumentation_key = module.application_insights_assisstant.application_insights_instrumentation_key
  function_application_insights_connection_string   = module.application_insights_assisstant.application_insights_connection_string
  log_analytics_workspace_id                        = module.azure_log_analytics.log_analytics_id
  subnet_id                                         = var.subnet_id
  customer_managed_key                              = null
}

# UAI role assignments
resource "azurerm_role_assignment" "uai_assisstant_role_assignment_key_vault_secrets_user" {
  description          = "Role Assignment for uai to read secrets"
  scope                = module.key_vault_assisstant.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.user_assigned_identity_assisstant.user_assigned_identity_principal_id
  principal_type       = "ServicePrincipal"
}

# Function role assignment
resource "azurerm_role_assignment" "function_assisstant_role_assignment_storage_blob_data_contributor" {
  description          = "Role Assignment for function to interact with Open AI models"
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.function_assisstant.linux_function_app_principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "function_assisstant_role_assignment_cognitive_services_openai_user" {
  description          = "Role Assignment for function to interact with Azure Open AI"
  scope                = module.open_ai.cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.function_assisstant.linux_function_app_principal_id
  principal_type       = "ServicePrincipal"
}
