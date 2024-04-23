resource "azurerm_data_factory" "data_factory" {
  name                = var.adf_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  github_configuration {
    account_name = "esbran"
    branch_name = "adf_updates"
    git_url = "https://github.com/esbran/adforchestrator"
    repository_name = "adforchestrator"
    root_folder = "/"
  }
  dynamic "global_parameter" {
    for_each = var.global_parameters

    content {
      name  = global_parameter.value.name
      value = global_parameter.value.value
      type  = global_parameter.value.type
    }
    
  }
}