terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "ocg_netstack"
    }
  }
}

## Create a subnet for the GPU VMs 
module "create_subnets" {
  source = "./modules/network"
    for_each = var.cloudapp_subnets_cidrs_map
    subscription_id = var.subscription_id
    vnet_name= var.vnet_name
    vnet_resourcegroup_name = var.vnet_resourcegroup_name
    default_route_table_name = var.default_route_table_name
    cloud_subnet_name = "subnet-${var.app_name}-${var.env_name}-${each.key}-${data.azurerm_resource_group.existing_vnet_rg.location}"
    cloud_subnet_ip  = each.value
}

module "disk_encrypt_resource_grp" {
  source = "./modules/resourcegroups"
  subscription_id = var.subscription_id
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  vnet_name= var.vnet_name
  app_name = var.app_name
  env_name = var.env_name
  rg_name =  var.disk_encrypt_resource_grp_name

  depends_on = [module.create_subnets]
}

module "cloudapp_managed_identity" {
  source = "./modules/services" 
  rg_name = module.disk_encrypt_resource_grp.name
  app_name = var.app_name
  env_name = var.env_name
  resource_location = data.azurerm_resource_group.existing_vnet_rg.location
  depends_on = [module.disk_encrypt_resource_grp]
}

module "cloudapp_keyvault" {
  
  providers = {
    azurerm.kv_privateDNS = azurerm.kv_privateDNS
  }
  source = "./modules/keyvault"
  subscription_id = var.subscription_id
  vnet_name = var.vnet_name
  vnet_resourcegroup_name =  module.disk_encrypt_resource_grp.name
  location = data.azurerm_resource_group.existing_vnet_rg.location
  managed_principal_id = module.cloudapp_managed_identity.principal_id
  app_name = var.app_name
  env_name = var.env_name
  rg_name = var.disk_encrypt_resource_grp_name
  subnet_map = module.create_subnets
}
