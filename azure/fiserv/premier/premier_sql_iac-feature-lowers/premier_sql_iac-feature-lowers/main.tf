terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "premier_sql_iac_lowers"
    }
  }
}

## Create a subnet for the GPU VMs 
module "cloud_subnets" {
  source                   = "./modules/network"
  for_each                 = var.clouddb_subnets_cidrs_map
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
  rg_name                 = "db-des"

  depends_on = [module.cloud_subnets]
}

module "clouddb_managed_identity" {
  source            = "./modules/services"
  rg_name           = module.des_resource_grp.name
  app_name          = var.app_name
  env_name          = var.env_name
  resource_location = data.azurerm_resource_group.existing_vnet_rg.location
  depends_on        = [module.des_resource_grp]
}

module "clouddb_key_des_kv" {

  providers = {
    azurerm.kv_privateDNS = azurerm.kv_privateDNS
  }
  source                  = "./modules/keyvault"
  subscription_id         = var.subscription_id
  vnet_name               = var.vnet_name
  vnet_resourcegroup_name = module.des_resource_grp.name
  location                = data.azurerm_resource_group.existing_vnet_rg.location
  managed_principal_id    = module.clouddb_managed_identity.principal_id
  user_assigned_id        = module.clouddb_managed_identity.managed_id
  app_name                = var.app_name
  env_name                = var.env_name
  rg_name                 = "db-des"
  subnet_map              = module.cloud_subnets
}

module "db_resource_grp" {
  source                  = "./modules/resourcegroups"
  subscription_id         = var.subscription_id
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  vnet_name               = var.vnet_name
  app_name                = var.app_name
  env_name                = var.env_name
  rg_name                 = "db"
  depends_on              = [module.cloud_subnets]
}

module "sql_ilb_creator" {
  source              = "./modules/loadbalancer"
  subnet_map          = module.cloud_subnets
  resource_group_name = module.db_resource_grp.name
  lb_ipaddress        = cidrhost(module.cloud_subnets["db"].subnet_details.subnet_prefix[0], 4)
  load_balancer_config = {
    "lb_config" = {
      subnet_name     = "db"
      lb_name         = "${var.app_name}-${var.env_name}-sql"
      lb_port         = 1433
      probe_interval  = 10
      probe_threshold = 3
      location        = module.db_resource_grp.location
      lb_probe_path   = "/"
    }
  }
}


module "sql_vm_creator" {
  source                                   = "./modules/compute"
  vnet_resourcegroup_name                  = var.vnet_resourcegroup_name
  app_name                                 = var.app_name
  env_name                                 = var.env_name
  vnet_name                                = var.vnet_name
  subnet_map                               = module.cloud_subnets
  vm_specs                                 = var.vm_specs
  apm_number                               = var.apm_number
  ou_path                                  = var.ou_path
  vm_location                              = module.db_resource_grp.location
  managed_identity_ids                     = module.clouddb_managed_identity.managed_id
  managed_identity_name                    = module.clouddb_managed_identity.managed_identity_name
  disk_encryption_set_managed_identity_ids = [module.clouddb_managed_identity.managed_id]
  disk_encryption_set_name                 = module.clouddb_key_des_kv.des_name
  managed_identity_resource_group          = module.clouddb_key_des_kv.resource_group_name
  disk_encryption_set_id                   = module.clouddb_key_des_kv.name_id
  customer_managed_key_name                = module.clouddb_key_des_kv.key_name
  customer_managed_key_id                  = module.clouddb_key_des_kv.versionless_id
  keyvault_id                              = module.clouddb_key_des_kv.key_vault_id
  hostname_prefix                          = var.hostname_prefix
  active_directory_domain                  = var.active_directory_domain
  vm_resourcegroup_name                    = module.db_resource_grp.name
  load_balancer_backend_pool_id            = module.sql_ilb_creator.lb_backend_address_pool_id
  depends_on                               = [module.cloud_subnets, module.clouddb_key_des_kv]
}

module "premier_azureSQL" {
  source = "git::https://root:wK4Zcmhx_sgWDadt2VgR@gitlab.onefiserv.net/dataatscale/azure-sql-paas-solutions/azure-sql-database/azurerm-sql-db-server.git"

  #sql srv
  server_name           = "azsql-${var.app_name}-${var.env_name}"
  server_resource_group = module.db_resource_grp.name
  server_location       = module.db_resource_grp.location

  #administrative access
  saa_login_name = "sqladmin"
  
  ## The below is defined as a Group under Microsoft Entr in the Tenant. 
  aad_administrator = {
    login_username = var.azure_entra_group_id  # "SQL-dataatscale-lower"      
    object_id      = var.azure_entra_object_id # "5999eb51-6295-451c-80de-60411420d930" 
  }

  #network
  network_resource_group = var.vnet_resourcegroup_name                           #   "non-prod-azuresql-centralus-vnet-rg"
  vnet_name              = var.vnet_name                                         #  "non-prod-vnet-azuresql-centralus-2018"
  subnet_name            = module.cloud_subnets["db"].subnet_details.subnet_name #  "SN_sqlservers"

  #saa keyvault
  saa_keyvault_name           = module.clouddb_key_des_kv.kv_name             # "non-prod-kv-azure-2018" 
  saa_keyvault_resource_group = module.clouddb_key_des_kv.resource_group_name # "non-prod-azuresql-kv-rg"


  #tde keyvault
  tde_keyvault_name           = module.clouddb_key_des_kv.kv_name
  tde_keyvault_resource_group = module.clouddb_key_des_kv.resource_group_name

  ### Input variables for creating a DNS record:  Here the Mod's input variable = the Root Variable
  ###### IF the Call to the DNS mod is commented out, these variables simply won't be used anywhere. 
  dns_subscription_id = var.subscription_id_kvPrivateDNS # var.subscription_id_privateDNS  
  dns_client_id       = var.client_id_privateDNS
  dns_client_secret   = var.client_secret_privateDNS
}

module "premier_database" {
  source        = "git::https://root:MTvL5wUfvTz5y5V4FEsZ@gitlab.onefiserv.net/dataatscale/azure-sql-paas-solutions/azure-sql-database/azurerm-sql-db"
  sql_server_id = module.premier_azureSQL.o_sql_server_id
  databases = [
    ## Short_term_retention_days is the RPO .. default 30 days.
    { name : "NAV_AZURE", sku_name : "BC_Gen5_2", short_term_retention_days : 30 },
    { name : "SECURITY", sku_name : "BC_Gen5_2", short_term_retention_days : 30 },
    { name : "PremierMaster", sku_name : "BC_Gen5_2", short_term_retention_days : 30 }
  ]

}