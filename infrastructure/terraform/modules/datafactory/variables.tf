# General variables
variable "adf_service_name" {
  description = "Specifies the name of the data factory."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.adf_service_name) >= 2
    error_message = "Please specify a valid name."
  }
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

variable "location" {
  description = "Specifies the location of the resource group."
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "data_factory_global_parameters" {
  description = "Specifies the Azure Data Factory global parameters."
  type = map(object({
    type  = optional(string, "String")
    value = optional(any, "")
  }))
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      length([for type in values(var.data_factory_global_parameters)[*].type : type if !contains(["Array", "Bool", "Float", "Int", "Object", "String"], type)]) <= 0,
    ])
    error_message = "Please specify a valid global parameter configuration."
  }
}

variable "data_factory_github_repo" {
  description = "Specifies the Github repository configuration."
  type = object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      git_url         = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_azure_devops_repo" {
  description = "Specifies the Azure Devops repository configuration."
  type = object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      project_name    = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
      tenant_id       = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_published_content" {
  description = "Specifies the Azure Devops repository configuration."
  type = object(
    {
      parameters_file = string
      template_file   = string
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
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
