## Core Azure RM data ## 

# Pre-defined Resource Group of the VNet
data "azurerm_resource_group" "existing_vnet_rg" {
  name = var.vnet_resourcegroup_name
}

# Existing vnet
data "azurerm_virtual_network" "existing_vnet_rg" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.existing_vnet_rg.name
}
