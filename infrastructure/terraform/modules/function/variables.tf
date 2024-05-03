# General variables
variable "resource_group_name" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "location" {
  description = "Specifies the location of the resource group."
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "function_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.function_name) >= 2
    error_message = "Please specify a valid name."
  }
}

# Service variables
variable "function_application_settings" {
  description = "Specifies the videoindexer id"
  type        = map(string)
  sensitive   = false
}

variable "function_always_on" {
  description = "Specifies whther always on should be enabled on the function."
  type        = bool
  sensitive   = false
  default     = false
}

variable "function_code_path" {
  description = "Specifies the code location of the function."
  type        = string
  sensitive   = false
}

variable "function_storage_account_id" {
  description = "Specifies the resource id of the storage account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.function_storage_account_id)) == 9
    error_message = "Please specify a valid name."
  }
}

variable "function_share_name" {
  description = "Specifies the share name within the storage account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.function_share_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "function_key_vault_id" {
  description = "Specifies the resource id of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.function_key_vault_id)) == 9
    error_message = "Please specify a valid name."
  }
}

variable "function_user_assigned_identity_id" {
  description = "Specifies the resource id of the user assigned identity."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.function_user_assigned_identity_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "function_sku" {
  description = "Specifies the SKU for the function app."
  type        = string
  sensitive   = false
  default     = "EP1"
  validation {
    condition     = contains(["EP1", "EP2", "EP3"], var.function_sku)
    error_message = "Please use an allowed value: \"EP1\", \"EP2\", \"EP3\"."
  }
}

variable "function_application_insights_instrumentation_key" {
  description = "Specifies the instrumentation key of application insights."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.function_application_insights_instrumentation_key) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "function_application_insights_connection_string" {
  description = "Specifies the instrumentation key of application insights."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.function_application_insights_connection_string) >= 2
    error_message = "Please specify a valid name."
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

# Customer-managed key variables
variable "customer_managed_key" {
  description = "Specifies the customer managed key configurations."
  type = object({
    key_vault_id                     = string,
    key_vault_key_versionless_id     = string,
    user_assigned_identity_id        = string,
    user_assigned_identity_client_id = string,
  })
  sensitive = false
  nullable  = true
  default   = null
  validation {
    condition = alltrue([
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.key_vault_id, ""))) == 9,
      var.customer_managed_key == null || startswith(try(var.customer_managed_key.key_vault_key_versionless_id, ""), "https://"),
      var.customer_managed_key == null || length(split("/", try(var.customer_managed_key.user_assigned_identity_id, ""))) == 9,
      var.customer_managed_key == null || length(try(var.customer_managed_key.user_assigned_identity_client_id, "")) >= 2,
    ])
    error_message = "Please specify a valid resource ID."
  }
}
