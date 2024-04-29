# General varaibles
variable "location" {
  description = "The location where the Video Indexer account will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The ID of the resource group where the Video Indexer account will be created"
  type        = string
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "videoindexer_name" {
  description = "The name of the Video Indexer account"
  type        = string
}

# Service variables
variable "storage_account_id" {
  description = "The ID of the storage account to be used by the Video Indexer account"
  type        = string
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
