data "azurerm_client_config" "current" {
}

/*
data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = local.cmk_uai.name
  resource_group_name = local.cmk_uai.resource_group_name
}
*/

data "azapi_resource" "key_vault_key" {
  type      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name      = var.cmk_key_name
  parent_id = var.cmk_key_vault_id

  response_export_values = ["properties.keyUriWithVersion"]
}