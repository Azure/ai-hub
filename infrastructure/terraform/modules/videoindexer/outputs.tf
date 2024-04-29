output "videoindexer_id" {
  description = "Specifies the resource id of video indexer"
  value       = azapi_resource.videoindexer.id
}

output "videoindexer_account_id" {
  description = "Specifies the account id of video indexer"
  value       = azapi_resource.videoindexer.output.properties.accountId
}
