output "linux_function_app_id" {
  description = "Specifies the resource id of the function."
  sensitive   = false
  value       = azurerm_linux_function_app.linux_function_app.id
}

output "linux_function_app_default_hostname" {
  description = "Specifies the endpoint of the function."
  sensitive   = false
  value       = azurerm_linux_function_app.linux_function_app.default_hostname
}

output "linux_function_app_primary_key" {
  description = "Specifies the key of the function."
  sensitive   = true
  value       = data.azurerm_function_app_host_keys.function_app_host_keys_shortclip.primary_key
}

output "linux_function_app_principal_id" {
  description = "Specifies the principal id of the function."
  sensitive   = false
  value       = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
}
