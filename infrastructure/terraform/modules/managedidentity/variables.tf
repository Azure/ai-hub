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

variable "user_assigned_identity_name" {
  description = "Specifies the name of the user assigned identity."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.user_assigned_identity_name) >= 2
    error_message = "Please specify a valid name."
  } 
}