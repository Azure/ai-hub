terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.13.1"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4.2"
    }
  }
}
