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
      parameterValues       = {}
      parameterValueType    = null
      testLinks             = []
      testRequests          = []
    }
  })

  schema_validation_enabled = false
  response_export_values    = ["properties.connectionRuntimeUrl"]
}
