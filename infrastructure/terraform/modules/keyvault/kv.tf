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
  sku_name                      = var.key_vault_sku_name
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

resource "azapi_resource" "key_vault_key" {
  type                      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name                      = "cmk"
  parent_id                 = azurerm_key_vault.key_vault.id
  location                  = var.location
  schema_validation_enabled = false
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
              type = "Rotate"
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
  type                      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name                      = "cmkStorage"
  parent_id                 = azurerm_key_vault.key_vault.id
  location                  = var.location
  schema_validation_enabled = false
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
              type = "Rotate"
            }
            trigger = {
              timeAfterCreate = "P12M"
            }
          },
          {
            action = {
              type = "Notify"
            }
            trigger = {
              timeBeforeExpiry = "P30D"
            }
          },
        ]
      }
    }
  })
  response_export_values = ["properties.keyUriWithVersion"]
}
