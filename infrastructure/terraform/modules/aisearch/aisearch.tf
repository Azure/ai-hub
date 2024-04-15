locals {
  cmk_uai = {
    resource_group_name = split("/", var.cmk_uai_id)[4]
    name                = split("/", var.cmk_uai_id)[8]
  }
}

resource "azurerm_search_service" "search_service" {
  name                = var.search_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  partition_count     = var.partition_count
  replica_count       = var.replica_count
  public_network_access_enabled = false
  local_authentication_enabled = false
  identity {
    type = "SystemAssigned"
  }
  customer_managed_key_enforcement_enabled = false
  
}

resource "azurerm_private_endpoint" "search_service_endpoint" {
  name                = "${azurerm_search_service.search_service.name}-pe"
  location            = var.location
  resource_group_name = azurerm_search_service.search_service.resource_group_name

  custom_network_interface_name = "${azurerm_search_service.search_service.name}-nic"
  private_service_connection {
    name                           = "${azurerm_search_service.search_service.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_search_service.search_service.id
    subresource_names              = ["searchService"]
  }
  subnet_id = var.subnet_id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_search_service" {
  resource_id = azurerm_search_service.search_service.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_search_service" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_search_service.search_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_search_service.log_category_groups
    content {
      category_group = entry.value
    }
  }
}