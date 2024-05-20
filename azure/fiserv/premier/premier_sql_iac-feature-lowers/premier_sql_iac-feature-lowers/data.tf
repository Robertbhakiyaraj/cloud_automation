## Core Azure RM data ## 


# Pre-defined Resource Group of the VNet
data "azurerm_resource_group" "existing_vnet_rg" {
  name = var.vnet_resourcegroup_name
}

data "azurerm_client_config" "current_config" {}