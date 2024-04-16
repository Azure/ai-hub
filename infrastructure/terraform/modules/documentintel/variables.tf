variable "docintel_service_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.adf_service_name) >= 2
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