resource "azurerm_data_factory" "data_factory" {
  name                = var.adf_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  github_configuration {
    account_name = "esbran"
    branch_name = "main"
    git_url = "https://github.com/esbran/openaidatafactory"
    repository_name = "openaidatafactory"
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