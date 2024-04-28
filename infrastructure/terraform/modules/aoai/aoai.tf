# Create Azure Open AI instance

locals {
  cmk_uai = {
    resource_group_name = split("/", var.cmk_uai_id)[4]
    name                = split("/", var.cmk_uai_id)[8]
  }
}

resource "azurerm_cognitive_account" "cognitive_service" {
  name                = var.cognitive_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name = var.cognitive_service_name
  /* customer_managed_key {  
     key_vault_key_id   = jsondecode(data.azapi_resource.key_vault_key.output).properties.keyUriWithVersion 
   }
   */
  dynamic_throttling_enabled = false
  fqdns = [
    trimsuffix(replace(var.key_vault_uri, "https://", ""), "/")
  ]
  kind               = var.cognitive_service_kind
  local_auth_enabled = false
  network_acls {
    default_action = "Allow"
    ip_rules       = []
  }
  outbound_network_access_restricted = false
  public_network_access_enabled      = true
  sku_name                           = var.cognitive_service_sku
}
/*
resource "azurerm_private_endpoint" "cognitive_service_private_endpoint" {
  name                = "${azurerm_cognitive_account.cognitive_service.name}-pe"
  location            = var.location
  resource_group_name = azurerm_cognitive_account.cognitive_service.resource_group_name

  custom_network_interface_name = "${azurerm_cognitive_account.cognitive_service.name}-nic"
  private_service_connection {
    name                           = "${azurerm_cognitive_account.cognitive_service.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.cognitive_service.id
    subresource_names              = ["account"]
  }
  subnet_id = var.subnet_id
}x
*/
data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_cognitive_service" {
  resource_id = azurerm_cognitive_account.cognitive_service.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_cognitive_service" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_cognitive_account.cognitive_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

# Requires subscription to be onboarded
# resource "azapi_resource" "no_moderation_policy" {
#   type                      = "Microsoft.CognitiveServices/accounts/raiPolicies@2023-06-01-preview"
#   name                      = "NoModerationPolicy"
#   parent_id                 = azurerm_cognitive_account.cognitive_service.id
#   schema_validation_enabled = false
#   body = jsonencode({
#     displayName = ""
#     properties = {
#       basePolicyName = "Microsoft.Default"
#       type           = "UserManaged"
#       contentFilters = [
#         { name = "hate", blocking = false, enabled = true, allowedContentLevel = "High", source = "Prompt" },
#         { name = "sexual", blocking = false, enabled = true, allowedContentLevel = "High", source = "Prompt" },
#         { name = "selfharm", blocking = false, enabled = true, allowedContentLevel = "High", source = "Prompt" },
#         { name = "violence", blocking = false, enabled = true, allowedContentLevel = "High", source = "Prompt" },
#         { name = "hate", blocking = false, enabled = true, allowedContentLevel = "High", source = "Completion" },
#         { name = "sexual", blocking = false, enabled = true, allowedContentLevel = "High", source = "Completion" },
#         { name = "selfharm", blocking = false, enabled = true, allowedContentLevel = "High", source = "Completion" },
#         { name = "violence", blocking = false, enabled = true, allowedContentLevel = "High", source = "Completion" },
#       ]
#     }
#   })
# }

resource "azurerm_cognitive_deployment" "gpt-4" {
  name                 = "gpt-4"
  cognitive_account_id = azurerm_cognitive_account.cognitive_service.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "1106-Preview"
  }
  scale {
    type = "Standard"
  }
}
