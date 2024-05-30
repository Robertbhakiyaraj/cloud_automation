# #Lookup existing resource group name
data "azurerm_resource_group" "existing_rg" {
  name = var.storage_rg
}

# #Lookup existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resourcegroup_name
}

# #Lookup existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resourcegroup_name
}

data "azurerm_key_vault" "existing_keyvault" {
    name = var.keyvault_name 
    resource_group_name = var.keyvault_rg
}

data "azurerm_storage_account" "storage-account-oracle" {
  name                = "epploweroraclesa"
  resource_group_name = var.storage_rg
  depends_on = [ module.storage_account_blob ]
}

data "azurerm_storage_account" "storage-account-autosys" {
  name                = "epplowerappssa"
  resource_group_name = var.storage_rg
  depends_on = [ module.storage_account_fileshare ]
}


