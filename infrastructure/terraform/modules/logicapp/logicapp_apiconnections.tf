data "azurerm_managed_api" "managed_apis" {
  for_each = var.logic_app_api_connections

  name     = each.key
  location = var.location
}

resource "azapi_resource" "api_connection_arm" {
  for_each = var.logic_app_api_connections

  type      = "Microsoft.Web/connections@2016-06-01"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  name      = "${var.logic_app_name}-api-${each.key}"
  location  = var.location
  tags      = var.tags

  body = jsonencode({
    kind = each.value.kind
    properties = {
      api = {
        name        = data.azurerm_managed_api.managed_apis[each.key].name
        displayName = each.value.display_name
        description = each.value.description
        iconUri     = "${each.value.icon_uri}/${data.azurerm_managed_api.managed_apis[each.key].name}/icon.png"
        brandColor  = each.value.brand_color
        id          = data.azurerm_managed_api.managed_apis[each.key].id
        type        = "Microsoft.Web/locations/managedApis"
      }
      # authenticatedUser = {}
      customParameterValues = {},
      displayName           = each.value.display_name
      parameterValues       = each.value.parameter_values
      parameterValueType    = null
      testLinks             = []
      testRequests          = []
    }
  })

  schema_validation_enabled = false
  response_export_values    = ["properties.connectionRuntimeUrl"]
}

resource "azurerm_resource_group_template_deployment" "api_connection_arm_access_policy" {
  for_each = var.logic_app_api_connections

  name                = "${var.logic_app_name}-api-${each.key}"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "connectionName": {
      "type": "string"
    },
    "principalId": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/connections/accessPolicies",
      "name": "[concat(parameters('connectionName'), '/', parameters('principalId'))]",
      "apiVersion": "2016-06-01",
      "location": "[resourceGroup().location]",
      "properties": {
        "principal": {
          "type": "ActiveDirectory",
          "identity": {
            "objectId": "[parameters('principalId')]",
            "tenantId": "[subscription().tenantId]"
          }
        }
      }
    }
  ]
}
TEMPLATE

  parameters_content = jsonencode(
    {
      "connectionName" = {
        value = "${var.logic_app_name}-api-${each.key}"
      },
      "principalId" = {
        value = "${azurerm_logic_app_standard.logic_app_standard.identity[0].principal_id}"
      }
    }
  )
}
