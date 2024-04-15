variable "location" {
    description = "Specifies the location for all Azure resources."
    type        = string
    sensitive   = false
}

variable "resource_group_name" {
    description = "Specifies the name of the resource group."
    type        = string
    sensitive   = false
    validation {
        condition     = length(var.resource_group_name) >= 2
        error_message = "Please specify a valid name."
    }
}

variable "key_vault_name" {
    description = "Specifies the name of the key vault."
    type        = string
    sensitive   = false
    validation {
        condition     = length(var.key_vault_name) >= 2
        error_message = "Please specify a valid name."
    }
}

variable "key_vault_sku_name" {
    description = "Select the SKU for the Key Vault"
    type = string
    sensitive = false
}

variable "log_analytics_workspace_id" {
  description = "Specifies the resource ID of the log analytics workspace used for the stamp"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.log_analytics_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_uai_id" {
  description = "Specifies the resource ID of the user assigned identity used for customer managed keys."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.cmk_uai_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_id" { 
  description = "Specifies the subnet ID."
  type        = string
  sensitive   = false
}