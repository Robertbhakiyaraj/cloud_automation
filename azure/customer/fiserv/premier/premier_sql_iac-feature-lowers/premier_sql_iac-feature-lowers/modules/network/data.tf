## Core Azure RM data ## 

# Existing route table
data "azurerm_route_table" "default_route_table" {
  name                = var.default_route_table_name
  resource_group_name = var.vnet_resourcegroup_name
}
