adf_service_name               = "myadfmabuss2973"
resource_group_name            = "base-rg"
location                       = "westeurope"
data_factory_azure_devops_repo = {}
data_factory_github_repo = {
  account_name    = "esbran"
  branch_name     = "main"
  git_url         = "https://github.com"
  repository_name = "openaidatafactory"
  root_folder     = "/"
}
data_factory_global_parameters = {
  mykey = {
    type  = "String"
    value = "myval"
  }
}
data_factory_published_content = {
  parameters_file = "./adfContent/ARMTemplateParametersForFactory.json"
  template_file   = "./adfContent/ARMTemplateForFactory.json"
}
custom_template_variables = {
  storage_account_id           = "/subscriptions/dfbd9ec6-9c65-43d6-bb61-bf7c4e221d9d/resourceGroups/base-rg/providers/Microsoft.Storage/storageAccounts/cloudshellmsftnp"
  function_shortclip_key       = ""
  function_shortclip_endpoint  = "https://myfunctiontst.azurewebsites.net"
  function_assisstant_key      = ""
  function_assisstant_endpoint = "https://assistantfunction.azurewebsites.net"
  keyvault_endpoint            = "https://esp1-swedencentral-kv.vault.azure.net/"
  storage_blob_endpoint        = "https://useme2.blob.core.windows.net/"
}
log_analytics_workspace_id = "/subscriptions/dfbd9ec6-9c65-43d6-bb61-bf7c4e221d9d/resourceGroups/DefaultResourceGroup-DEWC/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-dfbd9ec6-9c65-43d6-bb61-bf7c4e221d9d-DEWC"
subnet_id                  = ""
