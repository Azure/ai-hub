data "azurerm_client_config" "current" {}

locals {
  cmk_uai = {
    resource_group_name = split("/", var.cmk_uai_id)[4]
    name                = split("/", var.cmk_uai_id)[8]
  }
}

resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name

  access_policy                   = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = []
   virtual_network_subnet_ids = []
  }
  public_network_access_enabled = true
  purge_protection_enabled      = true
  sku_name                      = var.key_vault_sku_name
  soft_delete_retention_days    = 7
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_role_assignment" "umi_role_assignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = data.azurerm_user_assigned_identity.user_assigned_identity.principal_id
  skip_service_principal_aad_check = true
  
}

resource "azapi_resource" "key_vault_key" {
  type      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name      = "cmk"
  parent_id = azurerm_key_vault.key_vault.id

  body = jsonencode({
    properties = {
      attributes = {
        enabled    = true
        exportable = false
      }
      curveName = "P-256"
      keyOps = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      keySize = 2048
      kty     = "RSA"
      rotationPolicy = {
        attributes = {
          expiryTime = "P13M"
        }
        lifetimeActions = [
          {
            action = {
              type = "rotate"
            }
            trigger = {
              timeAfterCreate = "P12M"
            }
          }
        ]
      }
    }
  })
}

resource "azapi_resource" "key_vault_key_storage" {
  type      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name      = "cmkStorage"
  parent_id = azurerm_key_vault.key_vault.id

  body = jsonencode({
    properties = {
      attributes = {
        enabled    = true
        exportable = false
      }
      curveName = "P-256"
      keyOps = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      keySize = 2048
      kty     = "RSA"
      rotationPolicy = {
        attributes = {
          expiryTime = "P13M"
        }
        lifetimeActions = [
          {
            action = {
              type = "rotate"
            }
            trigger = {
              timeAfterCreate = "P12M"
            }
          }
        ]
      }
    }
  })
  response_export_values = ["properties.keyUriWithVersion"]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_key_vault" {
  resource_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_key_vault" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
/*
resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
  name = "${azurerm_key_vault.key_vault.name}-pe"
  location = var.location
  resource_group_name = var.resource_group_name
  custom_network_interface_name = "${azurerm_key_vault.key_vault.name}-nic"
  private_service_connection {
    name                           = "${azurerm_key_vault.key_vault.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }
  subnet_id = var.subnet_id
}
*/