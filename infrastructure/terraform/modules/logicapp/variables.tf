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

variable "logic_app_name" {
  description = "Specifies the name of the logic app."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.logic_app_name) >= 2
    error_message = "Please specify a valid name."
  }
}

# Service variables
variable "logic_app_application_settings" {
  description = "Specifies the videoindexer id"
  type        = map(string)
  sensitive   = false
}

variable "logic_app_always_on" {
  description = "Specifies whther always on should be enabled on the logic app."
  type        = bool
  sensitive   = false
  default     = false
}

variable "logic_app_code_path" {
  description = "Specifies the code location of the logic app."
  type        = string
  sensitive   = false
}

variable "logic_app_storage_account_id" {
  description = "Specifies the resource id of the storage account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.logic_app_storage_account_id)) == 9
    error_message = "Please specify a valid name."
  }
}

variable "logic_app_share_name" {
  description = "Specifies the share name within the storage account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.logic_app_share_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "logic_app_key_vault_id" {
  description = "Specifies the resource id of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.logic_app_key_vault_id)) == 9
    error_message = "Please specify a valid name."
  }
}

variable "logic_app_sku" {
  description = "Specifies the sku name used in the logic app app service plan."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "WS1"
  validation {
    condition     = contains(["WS1", "WS2", "WS3"], var.logic_app_sku)
    error_message = "Please specify a valid sku name."
  }
}

variable "logic_app_application_insights_instrumentation_key" {
  description = "Specifies the instrumentation key of application insights."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.logic_app_application_insights_instrumentation_key) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "logic_app_application_insights_connection_string" {
  description = "Specifies the instrumentation key of application insights."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.logic_app_application_insights_connection_string) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "logic_app_api_connections" {
  description = "Specifies the web connections of teh logic app."
  type = map(object({
    kind         = string
    display_name = string
    description  = string
    icon_uri     = string
    brand_color  = string
    category     = string
  }))
  sensitive = false
  default   = {}
  # validation {
  #   condition     = length(var.logic_app_application_insights_connection_string) >= 2
  #   error_message = "Please specify a valid name."
  # }
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
