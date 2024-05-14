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

variable "model_name" {
  description = "Specifies the name of the model."
  type        = string
  sensitive   = false
  default     = "gpt-4"
  validation {
    condition     = contains(["gpt-4"], var.model_name)
    error_message = "Please use an allowed value: \"gpt-4\"."
  }
}

variable "model_version" {
  description = "Specifies the name of the model."
  type        = string
  sensitive   = false
  default     = "1106-Preview"
  validation {
    condition     = contains(["1106-Preview", "turbo-2024-04-09"], var.model_version)
    error_message = "Please use an allowed value: \"1106-preview\"."
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
