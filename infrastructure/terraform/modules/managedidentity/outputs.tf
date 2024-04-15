output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.user_assigned_identity.id
  description = "The resourceId of the User Assigned Identity."
  sensitive   = false
}