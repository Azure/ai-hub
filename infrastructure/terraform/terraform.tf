terraform {
  required_version = ">=0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.100.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.13.0"
    }
  }

  backend "azurerm" {
    environment          = "public"
    resource_group_name  = "<provided-via-config>"
    storage_account_name = "<provided-via-config>"
    container_name       = "<provided-via-config>"
    key                  = "<provided-via-config>"
    # use_azuread_auth     = true
  }
}
