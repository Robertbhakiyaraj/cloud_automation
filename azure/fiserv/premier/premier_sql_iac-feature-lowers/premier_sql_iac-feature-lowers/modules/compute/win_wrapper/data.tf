## Core Azure RM data ## 
data "azurerm_key_vault_secret" "username" {
  name         = "EC-Domain-User"
  key_vault_id = "/subscriptions/fca7ddd8-7260-4499-bf70-e7835b2122d5/resourceGroups/prod-ictoaps-kv-rg/providers/Microsoft.KeyVault/vaults/prod-kv-ictoa-22d5"
}

data "azurerm_key_vault_secret" "password" {
  name         = "EC-Domain-Pwd"
  key_vault_id = "/subscriptions/fca7ddd8-7260-4499-bf70-e7835b2122d5/resourceGroups/prod-ictoaps-kv-rg/providers/Microsoft.KeyVault/vaults/prod-kv-ictoa-22d5"
}

data "template_file" "winrm_script" {
    template = file("${path.module}/winrm/SetWinRMCert.ps1")
}