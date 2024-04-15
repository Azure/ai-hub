locals {
  cmk_uai = {
    resource_group_name = split("/", var.cmk_uai_id)[4]
    name                = split("/", var.cmk_uai_id)[8]
  }
}

resource "azurerm_storage_account" "storage" {
  name                = var.storage_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
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
  /* 
  customer_managed_key {
     user_assigned_identity_id  = var.cmk_uai_id
     key_vault_key_id          = jsondecode(data.azapi_resource.key_vault_key.output).properties.keyUriWithVersion
   }
   */
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = true
  enable_https_traffic_only         = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  network_rules {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
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
  shared_access_key_enabled = true # Must be set to true until SPN/Pipeline can be used to access storage account via private endpoint
}

resource "azurerm_storage_management_policy" "storage_management_policy" {
  storage_account_id = azurerm_storage_account.storage.id

  rule {
    name    = "default"
    enabled = true
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 360
        # delete_after_days_since_modification_greater_than = 720
      }
      snapshot {
        change_tier_to_cool_after_days_since_creation = 180
        delete_after_days_since_creation_greater_than = 360
      }
      version {
        change_tier_to_cool_after_days_since_creation = 180
        delete_after_days_since_creation              = 360
      }
    }
    filters {
      blob_types   = ["blockBlob"]
      prefix_match = []
    }
  }
}

resource "azapi_resource" "storage_containers" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = "default"
  parent_id = "${azurerm_storage_account.storage.id}/blobServices/default"

  body = jsonencode({
    properties = {
      publicAccess = "None"
      metadata     = {}
    }
  })
}

#resource "azapi_resource" "symbolicname" {
#  type = "Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01"
#  name = "default"
#  parent_id = "${azurerm_storage_account.storage.id}/fileServices/default"
#  body = jsonencode({
#    properties = {
#      accessTier = "cool"
#      enabledProtocols = "SMB"
#      metadata = {}
#      rootSquash = "NoRootSquash"
#      shareQuota = 512
#      signedIdentifiers = [
#        {
#          
#        }
#      ]
#    }
#  })
#}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage" {
  resource_id = azurerm_storage_account.storage.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_storage" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_storage.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_storage.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

/*
 resource "azurerm_private_endpoint" "storage_private_endpoint_blob" {  
   name                = "${azurerm_storage_account.storage.name}-blob-pe"
   location            = var.location
   resource_group_name = azurerm_storage_account.storage.resource_group_name

   custom_network_interface_name = "${azurerm_storage_account.storage.name}-blob-nic"
   private_service_connection {
     name                           = "${azurerm_storage_account.storage.name}-blob-pe"
     is_manual_connection           = false
     private_connection_resource_id = azurerm_storage_account.storage.id
     subresource_names              = ["blob"]
   }
   subnet_id = var.subnet_id
}


 resource "azurerm_private_endpoint" "storage_private_endpoint_dfs" {
   name                = "${azurerm_storage_account.storage.name}-dfs-pe"
   location            = var.location
   resource_group_name = azurerm_storage_account.storage.resource_group_name

   custom_network_interface_name = "${azurerm_storage_account.storage.name}-dfs-nic"
   private_service_connection {
     name                           = "${azurerm_storage_account.storage.name}-dfs-pe"
     is_manual_connection           = false
     private_connection_resource_id = azurerm_storage_account.storage.id
     subresource_names              = ["dfs"]
   }
   subnet_id = var.subnet_id
}
*/