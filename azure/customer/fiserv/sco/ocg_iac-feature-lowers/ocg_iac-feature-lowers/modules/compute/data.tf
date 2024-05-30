### Gather Subnet Data ###
# Pre-Req - this must exist in subscription before running #

# Existing route table
data "azurerm_route_table" "default_route_table" {
  name                = var.default_route_table_name
  resource_group_name = var.vnet_resourcegroup_name
}

## Core Azure RM data ## 
data "azurerm_key_vault_secret" "username" {
  name         = "EC-Domain-User"
  key_vault_id = "/subscriptions/fca7ddd8-7260-4499-bf70-e7835b2122d5/resourceGroups/prod-ictoaps-kv-rg/providers/Microsoft.KeyVault/vaults/prod-kv-ictoa-22d5"
}

data "azurerm_key_vault_secret" "password" {
  name         = "EC-Domain-Pwd"
  key_vault_id = "/subscriptions/fca7ddd8-7260-4499-bf70-e7835b2122d5/resourceGroups/prod-ictoaps-kv-rg/providers/Microsoft.KeyVault/vaults/prod-kv-ictoa-22d5"
}

# Core Azure RM data ## 

# Pre-defined Resource Group of the VNet
data "azurerm_resource_group" "existing_vnet_rg" {
  name = var.vnet_resourcegroup_name
}

# Existing vnet
data "azurerm_virtual_network" "subnet_existing_vnet_rg" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing_vnet_rg.name
}

data "azurerm_subnet" "kv_subnet" {
  name                 = "subnet-${var.app_name}-${var.env_name}-keyvault"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resourcegroup_name
}
