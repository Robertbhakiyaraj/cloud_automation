## Core Azure RM data ## 

/*
data "azurerm_subnet" "kv_subnet" {
  ## HARD Coded.. Never changes
  name                 = "subnet-${var.app_name}-${var.env_name}-keyvault"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resourcegroup_name
}
*/
data "azurerm_client_config" "current_config" {}
