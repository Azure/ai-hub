output "logic_app_id" {
  description = "Specifies the resource id of the function."
  sensitive   = false
  value       = azurerm_logic_app_standard.logic_app_standard.id
}

output "logic_app_default_hostname" {
  description = "Specifies the endpoint of the function."
  sensitive   = false
  value       = azurerm_logic_app_standard.logic_app_standard.default_hostname
}

output "logic_app_primary_key" {
  description = "Specifies the key of the function."
  sensitive   = true
  value       = ""
}

output "logic_app_principal_id" {
  description = "Specifies the principal id of the function."
  sensitive   = false
  value       = azurerm_logic_app_standard.logic_app_standard.identity[0].principal_id
}
