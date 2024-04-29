# General variables
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

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
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

# Service variables
variable "key_vault_sku_name" {
  description = "Select the SKU for the Key Vault"
  type        = string
  sensitive   = false
}

variable "key_vault_keys" {
  description = "Specifies the key vault keys that should be deployed."
  type = map(object({
    curve    = optional(string, "P-256")
    key_size = optional(number, 2048)
    key_type = optional(string, "RSA")
  }))
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      length([for curve in values(var.key_vault_keys)[*].curve : curve if !contains(["P-256", "P-256K", "P-384", "P-521"], curve)]) <= 0,
      length([for key_type in values(var.key_vault_keys)[*].key_type : key_type if !contains(["EC", "EC-HSM", "RSA", "RSA-HSM"], key_type)]) <= 0,
    ])
    error_message = "Please specify a valid language extension."
  }
}

# Monitoring variables
variable "log_analytics_workspace_id" {
  description = "Specifies the resource ID of the log analytics workspace used for the stamp"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.log_analytics_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
variable "subnet_id" {
  description = "Specifies the subnet ID."
  type        = string
  sensitive   = false
}
