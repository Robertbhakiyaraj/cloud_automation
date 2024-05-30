### Environment ###
data "azurerm_client_config" "current_config" {}

data "azurerm_key_vault_secret" "username" {
  name         = "EC-Domain-User"
  key_vault_id = "/subscriptions/fca7ddd8-7260-4499-bf70-e7835b2122d5/resourceGroups/prod-ictoaps-kv-rg/providers/Microsoft.KeyVault/vaults/prod-kv-ictoa-22d5"
}

data "azurerm_key_vault_secret" "password" {
  name         = "EC-Domain-Pwd"
  key_vault_id = "/subscriptions/fca7ddd8-7260-4499-bf70-e7835b2122d5/resourceGroups/prod-ictoaps-kv-rg/providers/Microsoft.KeyVault/vaults/prod-kv-ictoa-22d5"
}


### Network - net01 ###
# Vnets #
# data "azurerm_virtual_network" "data_vnet_net01_cus" {
#   name                = var.net_stack["net01"].vnet_name_cus
#   resource_group_name = var.net_stack["net01"].vnet_rg_name_cus
# }
data "azurerm_virtual_network" "data_vnet_net01_eus2" {
  name                = var.net_stack["net01"].vnet_name_eus2
  resource_group_name = var.net_stack["net01"].vnet_rg_name_eus2
}
# Routing Tables
# data "azurerm_route_table" "data_rt_net01_cus" {
#   name                = var.net_stack["net01"].rt_name_cus
#   resource_group_name = data.azurerm_virtual_network.data_vnet_net01_cus.resource_group_name
# }
data "azurerm_route_table" "data_rt_net01_eus2" {
  name                = var.net_stack["net01"].rt_name_eus2
  resource_group_name = data.azurerm_virtual_network.data_vnet_net01_eus2.resource_group_name
}
