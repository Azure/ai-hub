variable "assistant_function_service_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.assistant_function_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "function_service_plan_name" {
  description = "Specifies the name of the function app service plan."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.function_service_plan_name) >= 2
    error_message = "Please specify a valid name."
  }
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

variable "location" {
  description = "Specifies the location of the resource group."
  type        = string
  sensitive   = false
}

variable "functions_storage_account_id" {
  description = "Specifies the name of the storage account Id."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.functions_storage_account_id) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "video_storage_account_id" {
  description = "Specifies the name of the storage account Id."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.video_storage_account_id) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "user_assigned_identity_id" {
  description = "Specifies the user assigned  of the storage account."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.user_assigned_identity_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "function_sku" {
  description = "Specifies the sku name used in the function app service plan."
  type        = string
  sensitive   = false
  nullable    = false
  default     = "Y1"
  validation {
    condition     = contains(["F1", "B1", "B2", "B3", "S1", "S2", "S3", "P0v3", "P1v3", "P2v3", "P3v3", "P1mv3", "P2mv3", "P3mv3", "P4mv3", "P5mv3", "EP1", "EP2", "EP3", "Y1"], var.function_sku)
    error_message = "Please specify a valid sku name."
  }
}

variable "shortclip_function_service_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.shortclip_function_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "cognitive_service_id" {
  description = "cognitive service resouceID."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_service_id) >= 2
    error_message = "Please specify a valid name."
  }
}
