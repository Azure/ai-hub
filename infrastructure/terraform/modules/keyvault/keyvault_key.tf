resource "azurerm_key_vault_key" "key_vault_key" {
  for_each = var.key_vault_keys

  name         = each.key
  key_vault_id = azurerm_key_vault.key_vault.id

  curve = each.value.curve
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]
  key_size = each.value.key_size
  key_type = each.value.key_type
  rotation_policy {
    expire_after         = "P13M"
    notify_before_expiry = "P20D"
    automatic {
      time_before_expiry = "P1M"
    }
  }

  depends_on = [
    azurerm_role_assignment.current_role_assignment_key_vault
  ]
}
