terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "premier_nav_iac_lowers"
    }
  }
}

## Create a subnet for the GPU VMs 
module "cloud_subnets" {
  source                   = "./modules/network"
  for_each                 = var.cloudapp_subnets_cidrs_map
  subscription_id          = var.subscription_id
  vnet_name                = var.vnet_name
  vnet_resourcegroup_name  = var.vnet_resourcegroup_name
  default_route_table_name = var.default_route_table_name
  cloud_subnet_name        = "subnet-${var.app_name}-${var.env_name}-${each.key}"
  cloud_subnet_ip          = each.value
}

module "des_resource_grp" {
  source                  = "./modules/resourcegroups"
  subscription_id         = var.subscription_id
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  vnet_name               = var.vnet_name
  app_name                = var.app_name
  env_name                = var.env_name
  rg_name                 = "des"

  depends_on = [module.cloud_subnets]
}

module "cloudapp_managed_identity" {
  source            = "./modules/services"
  rg_name           = module.des_resource_grp.name
  app_name          = var.app_name
  env_name          = var.env_name
  resource_location = data.azurerm_resource_group.existing_vnet_rg.location
  depends_on        = [module.des_resource_grp]
}

module "cloudapp_key_des_kv" {

  providers = {
    azurerm.kv_privateDNS = azurerm.kv_privateDNS
  }
  source                  = "./modules/keyvault"
  subscription_id         = var.subscription_id
  vnet_name               = var.vnet_name
  vnet_resourcegroup_name = module.des_resource_grp.name
  location                = data.azurerm_resource_group.existing_vnet_rg.location
  managed_principal_id    = module.cloudapp_managed_identity.principal_id
  user_assigned_id        = module.cloudapp_managed_identity.managed_id
  app_name                = var.app_name
  env_name                = var.env_name
  rg_name                 = "des"
  subnet_map              = module.cloud_subnets
}

module "app_resource_grp" {
  source                  = "./modules/resourcegroups"
  subscription_id         = var.subscription_id
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  vnet_name               = var.vnet_name
  app_name                = var.app_name
  env_name                = var.env_name
  rg_name                 = "app"
  depends_on              = [module.cloud_subnets]
}

module "ilb_creator" {
  source  = "./modules/loadbalancer" 
  subnet_map = module.cloud_subnets
  resource_group_name = module.app_resource_grp.name
  lb_subnet_cidr = module.cloud_subnets["service"].subnet_details.subnet_prefix[0]
  load_balancer_config = { 
    "lb_config" = {
    subnet_name = "service"
    lb_name = "${var.app_name}-${var.env_name}-service"
    lb_port = 443
    probe_interval = 10
    probe_threshold = 3
    location    = module.app_resource_grp.location
    lb_probe_path = "/"
    }
  }
}

module "vm_creator" {
  source                  = "./modules/compute"
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  app_name                = var.app_name
  env_name                = var.env_name
  vnet_name               = var.vnet_name
  subnet_map              = module.cloud_subnets
  vm_specs                = var.vm_specs
  apm_number              = var.apm_number
  vm_local_admin          = var.vm_local_admin
  should_join_domain      = var.should_join_domain
  ou_path                 = var.ou_path
  vm_location             = module.app_resource_grp.location
  managed_identity_ids    = module.cloudapp_managed_identity.managed_id
  managed_identity_name   = module.cloudapp_managed_identity.managed_identity_name
disk_encryption_set_managed_identity_ids = [module.cloudapp_managed_identity.managed_id]
  disk_encryption_set_name                 = module.cloudapp_key_des_kv.des_name
  managed_identity_resource_group          = module.cloudapp_key_des_kv.resource_group_name
  disk_encryption_set_id                   = module.cloudapp_key_des_kv.name_id
  customer_managed_key_name                = module.cloudapp_key_des_kv.key_name
  customer_managed_key_id                  = module.cloudapp_key_des_kv.versionless_id
  keyvault_id             = module.cloudapp_key_des_kv.key_vault_id
  hostname_prefix         = var.hostname_prefix
  active_directory_domain = var.active_directory_domain
  vm_resourcegroup_name   = module.app_resource_grp.name
  load_balancer_backend_pool_id        = module.ilb_creator.lb_backend_address_pool_id
  depends_on              = [module.cloud_subnets, module.cloudapp_key_des_kv]
}
