resource "azurerm_cognitive_account" "cognitive_service" {
  name                = var.cognitive_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name = var.cognitive_service_name
  # customer_managed_key {
  #   key_vault_key_id   = var.customer_managed_key.key_vault_key_versionless_id
  #   identity_client_id = var.customer_managed_key.user_assigned_identity_client_id
  # }
  dynamic_throttling_enabled = false
  fqdns = [
    # "${reverse(split(var.customer_managed_key.key_vault_id, "/"))[0]}.vault.azure.net",
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

# # Requires subscription to be onboarded
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
  name                 = var.gpt_model_name
  cognitive_account_id = azurerm_cognitive_account.cognitive_service.id

  model {
    format  = "OpenAI"
    name    = var.gpt_model_name
    version = var.gpt_model_version
  }
  scale {
    type = "Standard"
  }
}
