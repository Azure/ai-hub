resource "null_resource" "logic_app_app_deployment" {
  count = var.logic_app_code_path != "" ? 1 : 0

  triggers = {
    file = one(data.archive_file.file_logic_app[*].output_base64sha256)
  }

  provisioner "local-exec" {
    command = "az logicapp deployment source config-zip --resource-group ${azurerm_logic_app_standard.logic_app_standard.resource_group_name} --name ${azurerm_logic_app_standard.logic_app_standard.name} --src ${one(data.archive_file.file_logic_app[*].output_path)}"
  }
}
