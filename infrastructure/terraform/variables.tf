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

variable "data_factory_global_parameters" {
  description = "Specifies the Azure Data Factory global parameters."
  type = map(object({
    type  = optional(string, "String")
    value = optional(any, "")
  }))
  sensitive = false
  nullable  = false
  default = {
    temperature = {
      type  = "String",
      value = "1"
    },
    top_p = {
      type  = "String",
      value = "1"
    },
    category = {
      type  = "String",
      value = "metaprompt"
    },
    language = {
      type  = "String",
      value = "es-ES"
    },
    indexName = {
      type  = "String",
      value = "esp1Videos"
    },
    viRegion = {
      type  = "String",
      value = "eastus"
    },
    viAccountName = {
      type  = "String",
      value = "metaprompt"
    },
    viAccountId = {
      type  = "String",
      value = "metaprompt"
    },
  }
  validation {
    condition = alltrue([
      length([for type in values(var.data_factory_global_parameters)[*].type : type if !contains(["Array", "Bool", "Float", "Int", "Object", "String"], type)]) <= 0,
    ])
    error_message = "Please specify a valid global parameter configuration."
  }
}

# Network variables
variable "subnet_id" {
  type      = string
  sensitive = false
  default   = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/swedencentral-vnet/providers/Microsoft.Network/virtualNetworks/swedencentral-vnet/subnets/default"
}
