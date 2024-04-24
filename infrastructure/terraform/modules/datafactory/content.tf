resource "azurerm_resource_group_template_deployment" "data_factory_content_deployment" {
  count = var.data_factory_published_content.parameters_file != "" && var.data_factory_published_content.template_file != "" ? 1 : 0

  name                = "dataFactoryContentDeployment"
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  debug_level        = "none"
  deployment_mode    = "Incremental"
  parameters_content = jsonencode(jsondecode(templatefile(var.data_factory_published_content.parameters_file, local.template_variables)).parameters)
  template_content   = file(var.data_factory_published_content.template_file)
}
