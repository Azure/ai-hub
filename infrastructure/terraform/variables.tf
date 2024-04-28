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

variable "ingestion_rg_suffix" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  default     = "ingestion"
  validation {
    condition     = length(var.ingestion_rg_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "observability_rg_suffix" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  default     = "observability"
  validation {
    condition     = length(var.observability_rg_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "processing_rg_suffix" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  default     = "processing"
  validation {
    condition     = length(var.processing_rg_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "subnet_id" {
  type      = string
  sensitive = false
  default   = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/swedencentral-vnet/providers/Microsoft.Network/virtualNetworks/swedencentral-vnet/subnets/default"
}

variable "log_analytics_sku" {
  description = "Specifies the SKU for the log analytics workspace"
  type        = string
  sensitive   = false
  default     = "PerGB2018"
}

variable "key_vault_sku" {
  description = "Specifies the SKU for the key vault"
  type        = string
  sensitive   = false
  default     = "premium"
}

variable "key_vault_name_suffix" {
  description = "Specifies the name of the key vault."
  type        = string
  sensitive   = false
  default     = "kv"
  validation {
    condition     = length(var.key_vault_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "log_analytics_name_suffix" {
  description = "Specifies the name of the log analytics workspace"
  type        = string
  sensitive   = false
  default     = "law"
  validation {
    condition     = length(var.log_analytics_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "user_assigned_identity_name_suffix" {
  description = "Specifies the name of the user assigned identity."
  type        = string
  sensitive   = false
  default     = "uai"
  validation {
    condition     = length(var.user_assigned_identity_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "storage_account_name" {
  description = "Specifies the name of the storage account."
  type        = string
  default     = "esp2instai122311"
  sensitive   = false
  validation {
    condition     = length(var.storage_account_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "partition_count" {
  description = "Specifies the number of partitions in the search service."
  type        = number
  sensitive   = false
  default     = 1
}

variable "replica_count" {
  description = "Specifies the number of replicas in the search service."
  type        = number
  sensitive   = false
  default     = 1
}

variable "cognitive_service_name_suffix" {
  description = "Specifies the name of the search service."
  type        = string
  sensitive   = false
  default     = "aoai"
  validation {
    condition     = length(var.cognitive_service_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "videoindexer_name_suffix" {
  description = "Specifies the name of the search service."
  type        = string
  sensitive   = false
  default     = "vi"
  validation {
    condition     = length(var.videoindexer_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "search_service_name_suffix" {
  description = "Specifies the name of the search service."
  type        = string
  sensitive   = false
  default     = "search" #does not support '-' in name
  validation {
    condition     = length(var.search_service_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "adf_service_name_suffix" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  default     = "esp2-adf-pipelines"
  validation {
    condition     = length(var.adf_service_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "docintel_service_name_suffix" {
  description = "Specifies the name of the document intelligence service."
  type        = string
  sensitive   = false
  default     = "docintel"
  validation {
    condition     = length(var.docintel_service_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "function_name_suffix" {
  description = "Specifies the name of the function."
  type        = string
  sensitive   = false
  default     = "func"
  validation {
    condition     = length(var.function_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "azure_function_assistant_service_name_suffix" {
  description = "Specifies the name of the function."
  type        = string
  sensitive   = false
  default     = "assistant"
  validation {
    condition     = length(var.azure_function_assistant_service_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "azure_function_shortclip_service_name_suffix" {
  description = "Specifies the name of the function."
  type        = string
  sensitive   = false
  default     = "shortclip"
  validation {
    condition     = length(var.azure_function_shortclip_service_name_suffix) >= 2
    error_message = "Please specify a valid name."
  }
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
