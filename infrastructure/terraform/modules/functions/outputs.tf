output "function_assisstant_endpoint" {
  description = "Specifies the endpoint of the assisstant function."
  sensitive   = false
  value       = azurerm_linux_function_app.assistant_function.default_hostname
}

output "function_assisstant_key" {
  description = "Specifies the key of the assisstant function."
  sensitive   = false
  value       = data.azurerm_function_app_host_keys.function_app_host_keys_shortclip.primary_key
}

output "function_assisstant_shortclip" {
  description = "Specifies the key of the short clip function."
  sensitive   = false
  value       = data.azurerm_function_app_host_keys.function_app_host_keys_shortclip.primary_key
}

output "function_shortclip_endpoint" {
  description = "Specifies the endpoint of the short clip function."
  sensitive   = false
  value       = azurerm_linux_function_app.shortclip_function.default_hostname
}
