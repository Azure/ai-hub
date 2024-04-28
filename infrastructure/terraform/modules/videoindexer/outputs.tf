output "azapi_resource_videoindexer_id" {
  description = "Azure API Resource Video Indexer ID."
  value       = jsondecode(azapi_resource.videoindexer.output).properties.accountId
}
