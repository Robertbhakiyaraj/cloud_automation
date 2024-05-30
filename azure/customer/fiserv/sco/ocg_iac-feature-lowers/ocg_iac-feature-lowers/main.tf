terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "ocg_iac_lowers"
    }
  }
}

## Create All Required Subnets 
module "cloud_subnets" {
  source = "./modules/network"
    for_each = var.cloudapp_subnets_cidrs_map
    subscription_id = var.subscription_id
    vnet_name= var.vnet_name
    vnet_resourcegroup_name = var.vnet_resourcegroup_name
    default_route_table_name = var.default_route_table_name
    cloud_subnet_name = "subnet-${var.app_name}-${var.env_name}-${each.key}"
    cloud_subnet_ip  = each.value
}

## Create Disk encryption set resource group
module "des_resource_grp" {
  source = "./modules/resourcegroups"
  subscription_id = var.subscription_id
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  vnet_name= var.vnet_name
  app_name = var.app_name
  env_name = var.env_name
  rg_name = "des"

  depends_on = [module.cloud_subnets]
}

## Create App Resource group
module "app_resource_grp" {
  source = "./modules/resourcegroups"
  subscription_id = var.subscription_id
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  vnet_name= var.vnet_name
  app_name = var.app_name
  env_name = var.env_name
  rg_name = "app"

  depends_on = [module.cloud_subnets]
}

## Managed Identity for Disk Encryption Set
module "cloudapp_managed_identity" {
  source = "./modules/services" 
  rg_name = module.des_resource_grp.name
  app_name = var.app_name
  env_name = var.env_name
  resource_location = data.azurerm_resource_group.existing_vnet_rg.location
  depends_on = [module.des_resource_grp]
}

## The Key Vault
module "cloudapp_key_des_kv" {
  
  providers = {
    azurerm.kv_privateDNS = azurerm.kv_privateDNS
  }
  source = "./modules/keyvault"
  subscription_id = var.subscription_id
  vnet_name = var.vnet_name
  vnet_resourcegroup_name =  module.des_resource_grp.name
  location = data.azurerm_resource_group.existing_vnet_rg.location
  managed_principal_id = module.cloudapp_managed_identity.principal_id
  app_name = var.app_name
  env_name = var.env_name
  rg_name = "des"
  subnet_map = module.cloud_subnets
}

## Create VMs as described by the VM_SPECS map variable
module "vm_creator" {
  source = "./modules/compute"
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  app_name = var.app_name
  env_name = var.env_name
  vnet_name= var.vnet_name
  subnet_map = module.cloud_subnets
  vm_specs = var.vm_specs
  apm_number = var.apm_number
  managed_identity_ids = module.cloudapp_managed_identity.principal_id
  managed_identity_name = module.cloudapp_managed_identity.managed_identity_name
  keyvault_id = module.cloudapp_key_des_kv.key_vault_id
  hostname_prefix = var.vm_naming_prefix
  vm_location = module.app_resource_grp.location
  ou_path = var.ou_path
  vm_local_admin = var.vm_local_admin
  active_directory_domain = var.active_directory_domain
  vm_resourcegroup_name = module.app_resource_grp.name
  
  depends_on = [module.cloudapp_key_des_kv ,
                module.cloud_subnets]
}