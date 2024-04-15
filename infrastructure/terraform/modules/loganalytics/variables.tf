variable "location" {
  description = "Specifies the location for the resource group and the log analytics workspace"
  type        = string
  sensitive   = false
}

variable "log_analytics_resource_group_name" {
  description = "Specifies the name of the resource group for the log analytics workspace"
  type        = string
  sensitive   = false
}

variable "log_analytics_name" {
  description = "Specifies the name of the log analytics workspace"
  type        = string
  sensitive   = false
}

variable "log_analytics_sku" {
  description = "Specifies the SKU for the log analytics workspace"
  type        = string
  sensitive   = false
}

variable "log_analytics_retention_in_days" {
  description = "Specifies the retention in days for the log analytics workspace"
  type        = number
  sensitive   = false
}