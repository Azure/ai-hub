output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.user_assigned_identity.id
  description = "Specifies the resource id of the user assigned identity."
  sensitive   = false
}

output "user_assigned_identity_principal_id" {
  value       = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  description = "Specifies the principal id of the user assigned identity."
  sensitive   = false
}

output "user_assigned_identity_client_id" {
  value       = azurerm_user_assigned_identity.user_assigned_identity.client_id
  description = "Specifies the client id of the user assigned identity."
  sensitive   = false
}
