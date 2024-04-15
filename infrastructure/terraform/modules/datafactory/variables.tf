variable "sku" {
  description = "Specifies the SKU for the search service"
  type        = string
  sensitive   = false
  default     = "standard"
  
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

variable "log_analytics_workspace_id" {
  description = "Specifies the resource ID of the log analytics workspace used for the stamp"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.log_analytics_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_id" { 
  description = "Specifies the subnet ID."
  type        = string
  sensitive   = false
}