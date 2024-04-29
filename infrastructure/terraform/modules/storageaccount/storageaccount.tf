resource "azurerm_storage_account" "storage" {
  name                = var.storage_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  access_tier                     = "Hot"
  account_kind                    = "StorageV2"
  account_replication_type        = "ZRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  allowed_copy_scope              = "AAD"
  blob_properties {
    change_feed_enabled = false
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days = 7
    }
    default_service_version  = "2020-06-12"
    last_access_time_enabled = false
    versioning_enabled       = false
  }
  # customer_managed_key {
  #   user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
  #   key_vault_key_id          = var.customer_managed_key.key_vault_key_versionless_id
  # }
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = true
  enable_https_traffic_only         = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  nfsv3_enabled                 = false
  public_network_access_enabled = true
  queue_encryption_key_type     = "Account"
  table_encryption_key_type     = "Account"
  routing {
    choice                      = "MicrosoftRouting"
    publish_internet_endpoints  = false
    publish_microsoft_endpoints = false
  }
  sftp_enabled              = false
  shared_access_key_enabled = var.storage_account_shared_access_key_enabled
}

resource "azurerm_storage_container" "storage_container" {
  for_each = toset(var.storage_account_container_names)

  name                 = each.key
  storage_account_name = azurerm_storage_account.storage.name

  container_access_type = "private"
  metadata              = {}

  depends_on = [
    azurerm_role_assignment.current_role_assignment_storage_blob_data_owner
  ]
}

resource "azurerm_storage_share" "storage_share" {
  for_each = toset(var.storage_account_share_names)

  name                 = each.key
  storage_account_name = azurerm_storage_account.storage.name

  access_tier      = "TransactionOptimized"
  enabled_protocol = "SMB"
  quota            = 102400
}

# resource "azurerm_storage_management_policy" "storage_management_policy" {
#   storage_account_id = azurerm_storage_account.storage.id

#   rule {
#     name    = "default"
#     enabled = true
#     actions {
#       base_blob {
#         tier_to_cool_after_days_since_modification_greater_than = 360
#         # delete_after_days_since_modification_greater_than = 720
#       }
#       snapshot {
#         change_tier_to_cool_after_days_since_creation = 180
#         delete_after_days_since_creation_greater_than = 360
#       }
#       version {
#         change_tier_to_cool_after_days_since_creation = 180
#         delete_after_days_since_creation              = 360
#       }
#     }
#     filters {
#       blob_types   = ["blockBlob"]
#       prefix_match = []
#     }
#   }
# }
