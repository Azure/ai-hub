# General variables
variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
  default     = "eastus"
}

variable "prefix" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
  default     = "esp2"
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["dev", "tst", "qa", "prd"], var.environment)
    error_message = "Please use an allowed value: \"dev\", \"tst\", \"qa\" or \"prd\"."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "videoindexer_api_key" {
  description = "Specifies the API Key for Video Indexer."
  type        = string
  sensitive   = true
}

variable "function_sku" {
  description = "Specifies the SKU for the function app."
  type        = string
  sensitive   = false
  default     = "EP1"
}

# Network variables
variable "subnet_id" {
  type      = string
  sensitive = false
  default   = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/swedencentral-vnet/providers/Microsoft.Network/virtualNetworks/swedencentral-vnet/subnets/default"
}
