variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
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

variable "cognitive_service_name" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "cognitive_service_kind" {
  description = "Specifies the kind of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = contains(["AnomalyDetector", "ComputerVision", "CognitiveServices", "ContentModerator", "CustomVision.Training", "CustomVision.Prediction", "Face", "FormRecognizer", "ImmersiveReader", "LUIS", "Personalizer", "SpeechServices", "TextAnalytics", "TextTranslation", "OpenAI"], var.cognitive_service_kind)
    error_message = "Please specify a valid kind."
  }
}

variable "cognitive_service_sku" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_service_sku) >= 1
    error_message = "Please specify a valid sku name."
  }
}

variable "log_analytics_workspace_id" {
  description = "Specifies the resource ID of the log analytics workspace used for the stamp"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.log_analytics_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_uai_id" {
  description = "Specifies the resource ID of the user assigned identity used for customer managed keys."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.cmk_uai_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_key_vault_id" {
  description = "Specifies the resource ID of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.cmk_key_vault_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_key_name" {
  description = "Specifies the resource ID of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cmk_key_name) >= 2
    error_message = "Please specify a valid resource ID."
  }
}

variable "key_vault_uri" {
  description = "Specifies the URI of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.key_vault_uri) >= 2
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_id" {
  description = "Specifies the subnet ID."
  type        = string
  sensitive   = false
}