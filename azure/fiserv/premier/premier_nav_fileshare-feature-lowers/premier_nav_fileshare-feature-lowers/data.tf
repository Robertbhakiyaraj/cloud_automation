
# Lookup existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resourcegroup_name
}

# Lookup existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = "subnet-${var.app_name}-${var.env_name}-${var.filestore_subnet_name}"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resourcegroup_name
}

data "azurerm_key_vault" "existing_keyvault" {
    name = "kv-${var.app_name}-${var.env_name}-des"
    resource_group_name = "rg-${var.app_name}-${var.env_name}-des-${var.location}"
}