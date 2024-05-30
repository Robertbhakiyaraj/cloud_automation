
# Resource Groups
# module "rg_sql01_cus" {
#   source   = "jlqpztfe01.onefiserv.net/fiserv-main/resource-group/azurerm"
#   version  = "1.0.12"
#   name     = var.sql_stack["sql01"].environment.rg_name_cus
#   location = data.azurerm_virtual_network.data_vnet_net01_cus.location
#   depends_on = [
#     module.subnet_net01
#   ]
# }
module "rg_sql01_eus2" {
  source   = "jlqpztfe01.onefiserv.net/fiserv-main/resource-group/azurerm"
  version  = "1.0.12"
  name     = var.sql_stack["sql01"].environment.rg_name_eus2
  location = data.azurerm_virtual_network.data_vnet_net01_eus2.location
  depends_on = [
    module.subnet_net01
  ]
}



