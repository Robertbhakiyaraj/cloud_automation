module "cloudapp_subnets" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/subnets/azurerm"
  version = "1.0.14"

  subnets = {
    subnet1 = {
      name                 =  var.cloud_subnet_name
      resource_group_name  =  var.vnet_resourcegroup_name
      virtual_network_name =  var.vnet_name
      address_prefixes     =  [var.cloud_subnet_ip]
      service_endpoints    =  ["Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web", "Microsoft.Storage", "Microsoft.AzureActiveDirectory"]
      pe_enable            =  false
      delegation = [ {
        name = "hostingEnvironmentsService"
        service_delegation = [
            {
              name    = "Microsoft.Web/hostingEnvironments"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action", 
                         "Microsoft.Network/virtualNetworks/subnets/join/action", 
                        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", 
                        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
                        ]
            }
        ]
      }
      ]
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_associate_snet" {
  subnet_id      = module.cloudapp_subnets.subnet_id[0]
  route_table_id = data.azurerm_route_table.default_route_table.id
  depends_on = [
    module.cloudapp_subnets
  ]
}
