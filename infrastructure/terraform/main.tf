provider "azurerm" {
  tenant_id       = "572cf1ec-3f90-49a2-896f-ab2fa36ca0d3"
  subscription_id = "be25820a-df86-4794-9e95-6a45cd5c0941"
  client_id       = ""
  client_secret   = ""
  environment     = "public"
    features {
   # key_vault {
   #   recover_soft_deleted_key_vaults   = true
   #   recover_soft_deleted_certificates = true
   #   recover_soft_deleted_keys         = true
   #   recover_soft_deleted_secrets      = true
   # }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_subscription" "current" {
}
terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.9.0"
    }
  }
}

resource "azurerm_resource_group" "azureVideoWorkload_rg" {
  name     = var.azureVideoWorkload_rg
  location = var.location
}

resource "azurerm_resource_group" "observability_rg" {
  name     = var.observability_rg
  location = var.location
}