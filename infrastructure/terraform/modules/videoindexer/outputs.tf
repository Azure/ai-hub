output "azapi_resource_videoindexer_id" {
  description = "Azure API Resource Video Indexer ID."
  value       = jsondecode(azapi_resource.videoindexer.output).properties.accountId
}

output "videoindexer_id" {
  description = "Specifies the resource if of the Video Indexer."
  value       = azapi_resource.videoindexer.id
}
