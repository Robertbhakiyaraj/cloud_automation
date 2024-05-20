module "storage_account_blob" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/storageaccount/azurerm"
  version = "1.2.1"

  key_vault_id            = data.azurerm_key_vault.existing_keyvault.id
  key_vault_key           = null

  providers = {
    azurerm.sa_privateDNS = azurerm.sa_privateDNS
  }

  pe_subnet_id = data.azurerm_subnet.existing_subnet.id
  
  
  storage_accounts = var.storage_account_specs_db

  containers = var.containers_specs

  blobs = var.blobs_specs
  
}

module "storage_account_fileshare" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/storageaccount/azurerm"
  version = "1.2.1"

  key_vault_id            = data.azurerm_key_vault.existing_keyvault.id
  key_vault_key           = null

  providers = {
    azurerm.sa_privateDNS = azurerm.sa_privateDNS
  }

  pe_subnet_id = data.azurerm_subnet.existing_subnet.id
  
  
  storage_accounts = var.storage_account_specs_apps
  
  file_shares = var.file_share_specs


}

