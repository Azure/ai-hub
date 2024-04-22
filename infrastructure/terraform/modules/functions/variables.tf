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

variable "storage_account_name" {
    description = "Specifies the name of the storage account."
    type        = string
    sensitive   = false
    validation {
        condition     = length(var.storage_account_name) >= 2
        error_message = "Please specify a valid name."
    }
  
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
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