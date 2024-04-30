resource "null_resource" "linux_function_app_deployment" {
  count = var.function_code_path != "" ? 1 : 0

  triggers = {
    file = one(data.archive_file.file_function[*].output_base64sha256)
  }

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip --resource-group ${azurerm_linux_function_app.linux_function_app.resource_group_name} --name ${azurerm_linux_function_app.linux_function_app.name} --src ${one(data.archive_file.file_function[*].output_path)} --build-remote true"
  }
}
