resource "azurerm_data_factory" "data_factory" {
  name                = var.adf_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  managed_virtual_network_enabled = false # Change in prod
  public_network_enabled          = true  # Change in prod
  dynamic "global_parameter" {
    for_each = var.data_factory_global_parameters
    content {
      name  = global_parameter.key
      type  = global_parameter.value.type
      value = global_parameter.value.value
    }
  }
  dynamic "github_configuration" {
    for_each = length(compact(values(var.data_factory_github_repo))) == 5 ? [var.data_factory_github_repo] : []
    content {
      account_name    = github_configuration.value["account_name"]
      branch_name     = github_configuration.value["branch_name"]
      git_url         = github_configuration.value["git_url"]
      repository_name = github_configuration.value["repository_name"]
      root_folder     = github_configuration.value["root_folder"]
    }
  }
  dynamic "vsts_configuration" {
    for_each = length(compact(values(var.data_factory_azure_devops_repo))) == 6 ? [var.data_factory_azure_devops_repo] : []
    content {
      account_name    = vsts_configuration.value["account_name"]
      branch_name     = vsts_configuration.value["branch_name"]
      project_name    = vsts_configuration.value["project_name"]
      repository_name = vsts_configuration.value["repository_name"]
      root_folder     = vsts_configuration.value["root_folder"]
      tenant_id       = vsts_configuration.value["tenant_id"]
    }
  }
}
