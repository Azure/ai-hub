resource "azurerm_resource_group_template_deployment" "data_factory_content_deployment" {
  name = "dataFactoryContentDeployment"
  resource_group_name = var.resource_group_name
  tags = var.tags

  debug_level = "none"
  deployment_mode = "Incremental"
  parameters_content = 
  template_content = 
}