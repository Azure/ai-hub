output "function_assisstant_endpoint" {
  description = "Specifies the endpoint of the assisstant function."
  sensitive   = false
  value       = azurerm_linux_function_app.assistant_function.default_hostname
}

output "function_shortclip_endpoint" {
  description = "Specifies the endpoint of the short clip function."
  sensitive   = false
  value       = azurerm_linux_function_app.shortclip_function.default_hostname
}
