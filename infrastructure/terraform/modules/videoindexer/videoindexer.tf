resource "azurerm_template_deployment" "videoindexer" {
  name                = var.vi_service_name
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  template_body       = file("modules/videoindexer/templates/videoindexer.json",) 
  parameters = {
    rgName = var.resource_group_name
    location = var.location
    prefix = "ebk"
    videoSystemIdentity = var.videoSystemIdentity
    videoMonCreation = var.videoMonCreation
  }
}