### Network Stack 01 ###
# Subnets #
module "subnet_net01" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/subnets/azurerm"
  version = "1.0.14" # Example. Change this as necessary

  subnets = {
    #  IaaS SQL on VMs subnet (centralus)
    # subnet1 = {
    #   name                 = var.net_stack["net01"].subnet_name_cus
    #   resource_group_name  = data.azurerm_virtual_network.data_vnet_net01_cus.resource_group_name
    #   virtual_network_name = data.azurerm_virtual_network.data_vnet_net01_cus.name
    #   address_prefixes     = [var.net_stack["net01"].subnet_cidr_cus]
    #   service_endpoints    = ["Microsoft.KeyVault"]
    #   pe_enable            = false
    #   delegation           = []
    # }
    # IaaS SQL on VMs subnet (eastus2)
    subnet2 = {
      name                 = var.net_stack["net01"].subnet_name_eus2
      resource_group_name  = data.azurerm_virtual_network.data_vnet_net01_eus2.resource_group_name
      virtual_network_name = data.azurerm_virtual_network.data_vnet_net01_eus2.name
      address_prefixes     = [var.net_stack["net01"].subnet_cidr_eus2]
      service_endpoints    = ["Microsoft.KeyVault"]
      pe_enable            = false
      delegation           = []
    }
  }
}

# Associate route tables
# resource "azurerm_subnet_route_table_association" "rt_associate_net01_cus" {
#   subnet_id      = module.subnet_net01.subnet_id[0]
#   route_table_id = data.azurerm_route_table.data_rt_net01_cus.id
#   depends_on = [
#     module.subnet_net01
#   ]
# }
resource "azurerm_subnet_route_table_association" "rt_associate_net01_eus2" {
  subnet_id      = module.subnet_net01.subnet_id[0]
  route_table_id = data.azurerm_route_table.data_rt_net01_eus2.id
  depends_on = [
    module.subnet_net01
  ]
}
