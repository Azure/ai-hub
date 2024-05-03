# General variables
variable "location" {
  description = "Specifies the location for the resource group and the log analytics workspace"
  type        = string
  sensitive   = false
}

variable "resource_group_name" {
  description = "Specifies the name of the resource group for the log analytics workspace"
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "log_analytics_name" {
  description = "Specifies the name of the log analytics workspace"
  type        = string
  sensitive   = false
}

# Service variables
variable "log_analytics_retention_in_days" {
  description = "Specifies the retention in days for the log analytics workspace"
  type        = number
  sensitive   = false
}
