resource "azurerm_data_factory" "data_factory" {
  name                = var.adf_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags

  managed_virtual_network_enabled = false # Change in prod
  public_network_enabled          = true  # Change in prod

  dynamic "global_parameter" {
    for_each = var.data_factory_global_parameters
    content {
      name  = each.key
      type  = each.value.type
      value = each.value.value
    }
  }
  dynamic "github_repo" {
    for_each = length(compact(values(var.data_factory_github_repo))) == 5 ? [var.data_factory_github_repo] : []
    content {
      account_name    = github_repo.value["account_name"]
      branch_name     = github_repo.value["branch_name"]
      git_url         = github_repo.value["git_url"]
      repository_name = github_repo.value["repository_name"]
      root_folder     = github_repo.value["root_folder"]
    }
  }
  dynamic "vsts_configuration" {
    for_each = length(compact(values(var.data_factory_azure_devops_repo))) == 6 ? [var.data_factory_azure_devops_repo] : []
    content {
      account_name    = azure_devops_repo.value["account_name"]
      branch_name     = azure_devops_repo.value["branch_name"]
      project_name    = azure_devops_repo.value["project_name"]
      repository_name = azure_devops_repo.value["repository_name"]
      root_folder     = azure_devops_repo.value["root_folder"]
      tenant_id       = azure_devops_repo.value["tenant_id"]
    }
  }
}
