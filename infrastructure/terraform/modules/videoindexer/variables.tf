variable "videoindexer_name" {
  description = "The name of the Video Indexer account"
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group where the Video Indexer account will be created"
  type        = string
}

variable "location" {
  description = "The location where the Video Indexer account will be created"
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the storage account to be used by the Video Indexer account"
  type        = string
}