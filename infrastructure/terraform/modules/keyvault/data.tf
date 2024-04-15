data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = local.cmk_uai.name
  resource_group_name = local.cmk_uai.resource_group_name
}