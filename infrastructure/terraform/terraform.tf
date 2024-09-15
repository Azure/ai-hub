terraform {
  required_version = ">=0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.14.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}
