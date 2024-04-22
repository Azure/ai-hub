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

variable "azureVideoWorkload_rg" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  default     = "esp2-eastus-rg"
  validation {
    condition     = length(var.azureVideoWorkload_rg) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "observability_rg" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  default     = "esp2-logw-eastus-rg"
  validation {
    condition     = length(var.observability_rg) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "subnet_id" { 
  description = "Specifies the resourceId of an existing subnet, in the same region as the rest of the workloads that will be created."
  type        = string
  sensitive   = false
  default = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/swedencentral-vnet/providers/Microsoft.Network/virtualNetworks/swedencentral-vnet/subnets/default"
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

variable "key_vault_name" {
  description = "Specifies the name of the key vault."
  type        = string
  sensitive   = false
  default     = "esp2-azsecret-eastus-kv"
  validation {
    condition     = length(var.key_vault_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "log_analytics_name" {
  description = "Specifies the name of the log analytics workspace"
  type        = string
  sensitive   = false
  default     = "esp2azlogs-law"
    validation {
    condition     = length(var.log_analytics_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "cognitive_service_name" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  default     = "esp2azoai-ai"
  validation {
    condition     = length(var.cognitive_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "user_assigned_identity_name" {
  description = "Specifies the name of the user assigned identity."
  type        = string
  sensitive   = false
  default     = "esp2-id-eastus-uai"
  validation {
    condition     = length(var.user_assigned_identity_name) >= 2
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

variable "search_service_name" {
  description = "Specifies the name of the search service."
  type        = string
  sensitive   = false
  default     = "esp2azsearcheastusss" #does not support '-' in name
  validation {
    condition     = length(var.search_service_name) >= 2
    error_message = "Please specify a valid name."
  }
  
}

variable "adf_service_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  default     = "esp2-adf-pipelines"
  validation {
    condition     = length(var.adf_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "docintel_service_name" {
  description = "Specifies the name of the document intelligence service."
  type        = string
  sensitive   = false
  default     = "esp2azdocintel-docintel"
  validation {
    condition     = length(var.docintel_service_name) >= 2
    error_message = "Please specify a valid name."
  }
  
}

variable "vi_service_name" {
  description = "Specifies the name of the video indexer service."
  type        = string
  sensitive   = false
  default     = "esp2azvi-vi2"
  validation {
    condition     = length(var.vi_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "videoSystemIdentity" {
  description = "Specifies the videoSystemIdentity."
  type        = string
  sensitive   = false
  default     = "No"
  validation {
    condition     = length(var.videoSystemIdentity) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "videoMonCreation" {
  description = "Specifies the videoMonCreation."
  type        = string
  sensitive   = false
  default     = "No"
  validation {
    condition     = length(var.videoMonCreation) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "assistant_function_service_name" {
  description = "Specifies the name of the function."
  type        = string
  sensitive   = false
  default = "func"
  validation {
    condition     = length(var.assistant_function_service_name) >= 2
    error_message = "Please specify a valid name."
  } 
}

variable "function_service_plan_name" {
  description = "Specifies the name of the function app service plan."
  type        = string
  sensitive   = false
  default = "funcplan"
  validation {
    condition     = length(var.function_service_plan_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "function_sku" {
  description = "Specifies the SKU for the function app."
  type        = string
  sensitive   = false
  default     = "EP1"
  
}