############################################################################
### https://github.com/hashicorp/terraform-provider-azurerm/issues/25776 ###
############################################################################

# resource "azapi_resource" "shortclip_function_code_deploy" {
#   schema_validation_enabled = false
#   type                      = "Microsoft.Web/sites/extensions@2022-03-01"
#   name                      = "/ZipDeploy"
#   parent_id                 = azurerm_linux_function_app.shortclip_function.id
#   location                  = var.location
#   body = jsonencode({
#     properties = {
#       "packageUri" : "https://github.com/Azure/ai-hub/raw/main/infrastructure/terraform/modules/functions/rag.zip"
#       "appOffline" : true
#     }
#   })
# }

resource "azurerm_resource_group_template_deployment" "helloworld_function_code_deploy_nested_deployment" {
  name                = "code-deployment-${azurerm_storage_blob.helloworld_function_blob.name}"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServiceName": {
      "type": "string"
    },
    "packageUri": {
      "type": "secureString"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/sites/extensions",
      "apiVersion": "2021-02-01",
      "name": "[format('{0}/ZipDeploy', parameters('appServiceName'))]",
      "properties": {
        "packageUri": "[parameters('packageUri')]",
        "appOffline": true
      }
    }
  ]
}
TEMPLATE

  parameters_content = jsonencode({
    "appServiceName" : {
      "value" : "${azurerm_linux_function_app.helloworld_function.name}"
    },
    "packageUri" : {
      "value" : ("${azurerm_storage_blob.helloworld_function_blob.url}${data.azurerm_storage_account_sas.assistant_function_blob_sas.sas}")
    }
  })
}