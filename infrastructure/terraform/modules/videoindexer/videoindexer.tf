resource "azurerm_resource_group_template_deployment" "videoindexer" {
  name                = var.vi_service_name
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_content = file("modules/videoindexer/templates/videoindexer.json",) 
  parameters_content = jsonencode({
    "rgName" = {
      value = var.resource_group_name
    },
    "location" = {
      value = var.location
    },
    "prefix" = {
      value = var.prefix
    },
    "videoSystemIdentity" = {
      value = var.videoSystemIdentity
    },
    "videoMonCreation" = {
      value = var.videoMonCreation
  })
  
  {
    rgName = var.resource_group_name
    location = var.location
    prefix = "ebk"
    videoSystemIdentity = var.videoSystemIdentity
    videoMonCreation = var.videoMonCreation
  }
}