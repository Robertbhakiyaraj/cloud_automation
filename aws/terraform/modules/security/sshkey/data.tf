# Get existing Key Vault
data "azurerm_key_vault" "kv" {
  name                = var.azurerm_key_vault_name
  resource_group_name = var.azurerm_key_vault_resource_group_name
}
# Get existing Key
data "azurerm_key_vault_key" "ssh_key" {
  name         = var.azurerm_key_vault_key_name
  key_vault_id = data.azurerm_key_vault.kv.id
} 