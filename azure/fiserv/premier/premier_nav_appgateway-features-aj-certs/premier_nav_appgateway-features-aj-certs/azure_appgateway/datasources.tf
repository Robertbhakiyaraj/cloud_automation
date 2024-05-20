data "azurerm_resource_group" "appgateway_premier" {
  name     = var.appgateway_premier_resource_group_name
  provider = azurerm.appgateway_premier
}

# Use an existing resource group which contains your existing virtual network
data "azurerm_resource_group" "appgateway_premier_network_rg" {
  name     = var.appgateway_premier_vnet_resource_group_name
  provider = azurerm.appgateway_premier
}

# Use an existing virtual network
data "azurerm_virtual_network" "appgateway_premier" {
  resource_group_name = data.azurerm_resource_group.appgateway_premier_network_rg.name
  name                = var.appgateway_premier_vnet
  provider            = azurerm.appgateway_premier
}
