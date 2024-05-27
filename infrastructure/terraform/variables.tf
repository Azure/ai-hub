# General variables
variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
  default     = "swedencentral"
}

variable "prefix" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["int", "dev", "tst", "uat", "prd"], var.environment)
    error_message = "Please use an allowed value: \"int\", \"dev\", \"tst\", \"uat\" or \"prd\"."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Resource variables
variable "default_language" {
  description = "Specifies the default language to use for the service."
  type        = string
  sensitive   = false
  default     = "en-US"
  validation {
    condition     = contains(["en-US", "es-ES", "de-DE"], var.default_language)
    error_message = "Please use an allowed language."
  }
}

variable "cognitive_service_deployments" {
  description = "Specifies the name of the GPT model."
  type = map(object({
    model_name             = string
    model_version          = string
    model_api_version      = optional(string, "2024-02-15-preview")
    version_upgrade_option = optional(string, "OnceNewDefaultVersionAvailable")
    scale_type             = optional(string, "Standard")
    scale_tier             = optional(string, "Standard")
    scale_size             = optional(string, null)
    scale_family           = optional(string, null)
    scale_capacity         = optional(number, 1)
  }))
  sensitive = false
  default = {
    gpt-4 = {
      model_name    = "gpt-4"
      model_version = "turbo-2024-04-09"
    }
  }
  validation {
    condition = alltrue([
      length(var.cognitive_service_deployments) > 0
    ])
    error_message = "Please specify a valid model configuration."
  }
}

variable "logic_app_sku" {
  description = "Specifies the SKU for the logic app."
  type        = string
  sensitive   = false
  default     = "WS1"
  validation {
    condition     = contains(["WS1", "WS2", "WS3"], var.logic_app_sku)
    error_message = "Please use an allowed value: \"WS1\", \"WS2\", \"WS3\"."
  }
}

variable "logic_app_website_run_from_package" {
  description = "Specifies the logic app whether it should run as a package."
  type        = string
  sensitive   = false
  default     = "0"
  validation {
    condition     = contains(["1", "0"], var.logic_app_website_run_from_package)
    error_message = "Please use an allowed value: \"0\", \"1\"."
  }
}

variable "function_sku" {
  description = "Specifies the SKU for the function app."
  type        = string
  sensitive   = false
  default     = "EP1"
  validation {
    condition     = contains(["EP1", "EP2", "EP3"], var.function_sku)
    error_message = "Please use an allowed value: \"EP1\", \"EP2\", \"EP3\"."
  }
}

# Network variables
variable "subnet_id" {
  type      = string
  sensitive = false
  default   = "/subscriptions/be25820a-df86-4794-9e95-6a45cd5c0941/resourceGroups/swedencentral-vnet/providers/Microsoft.Network/virtualNetworks/swedencentral-vnet/subnets/default"
}
