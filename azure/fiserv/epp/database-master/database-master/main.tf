# Create Linux VM for Oracle
module "create_linux_vms_oracle" {
  source = "./modules/linux_vm"

  app_name                                   = var.app_name
  env_name                                   = var.env_name
  apm_number                                 = var.apm_number
  hostname_prefix                            = var.hostname_prefix

  vm_specs                                   = var.vm_specs_oracle
  keyvault_id                                = data.azurerm_key_vault.existing_kv.id
  vnet_rg                                    = data.azurerm_resource_group.existing_rg.name
  vm_rg                                      = data.azurerm_resource_group.existing_rg.name
  vm_location                                = var.vm_location
  subnet_id                                  = data.azurerm_subnet.existing_subnet.id
  managed_identity_ids                       = var.managed_identity_ids
  disk_encryption_set_resource_group_name    = var.disk_encryption_set_resource_group_name 
  disk_encryption_set_name                   = var.disk_encryption_set_name
  customer_managed_key_name                  = var.customer_managed_key_name  

  common_tags                                = var.common_tags

  disk_storage_types_oracle                      = var.disk_storage_types_oracle
  disk_sizes_gb_oracle                           = var.disk_sizes_gb_oracle
  disk_caching_oracle                            = var.disk_caching_oracle 
  disk_storage_types_observer                    = var.disk_storage_types_observer
  disk_sizes_gb_observer                         = var.disk_sizes_gb_observer
  disk_caching_observer                          = var.disk_caching_observer

}

# Create Linux VM for Observer
module "create_linux_vms_observer" {
  source = "./modules/linux_vm"

  app_name                                   = var.app_name
  env_name                                   = var.env_name
  apm_number                                 = var.apm_number
  hostname_prefix                            = var.hostname_prefix

  vm_specs                                   = var.vm_specs_observer
  keyvault_id                                = data.azurerm_key_vault.existing_kv.id
  vnet_rg                                    = data.azurerm_resource_group.existing_rg.name
  vm_rg                                      = data.azurerm_resource_group.existing_rg.name
  vm_location                                = var.vm_location
  subnet_id                                  = data.azurerm_subnet.existing_subnet.id
  managed_identity_ids                       = var.managed_identity_ids
  disk_encryption_set_resource_group_name    = var.disk_encryption_set_resource_group_name 
  disk_encryption_set_name                   = var.disk_encryption_set_name
  customer_managed_key_name                  = var.customer_managed_key_name  

  common_tags                                = var.common_tags

  disk_storage_types_oracle                      = var.disk_storage_types_oracle
  disk_sizes_gb_oracle                           = var.disk_sizes_gb_oracle
  disk_caching_oracle                            = var.disk_caching_oracle 
  disk_storage_types_observer                    = var.disk_storage_types_observer
  disk_sizes_gb_observer                         = var.disk_sizes_gb_observer
  disk_caching_observer                          = var.disk_caching_observer

}


# Create SG for Oracle
 module "create_network_security_group_oracle" {
   source = "./modules/security_group"

   app_name                                  = var.app_name
   env_name                                  = var.env_name
   apm_number                                = var.apm_number
   hostname_prefix                           = var.hostname_prefix

   vm_rg                                     = var.vm_rg
   network_security_group_spec               = var.network_security_group_spec_oracle
   nsg_resource_group_name                   = var.vnet_rg
   nsg_subnet_name                           = data.azurerm_subnet.existing_subnet.name
   nsg_vnet_name                             = var.vnet_name   

   environment                               = var.env_name
   tags                                      = var.common_tags
   nic_id                                    = local.filtered_network_interface_ids_oracle

   depends_on                                = [module.create_linux_vms_oracle]
 }

# Create SG for Observer
 module "create_network_security_group_observer" {
   source = "./modules/security_group"

   app_name                                  = var.app_name
   env_name                                  = var.env_name
   apm_number                                = var.apm_number
   hostname_prefix                           = var.hostname_prefix

   vm_rg                                     = var.vm_rg
   network_security_group_spec               = var.network_security_group_spec_observer
   nsg_resource_group_name                   = var.vnet_rg
   nsg_subnet_name                           = data.azurerm_subnet.existing_subnet.name
   nsg_vnet_name                             = var.vnet_name   

   environment                               = var.env_name
   tags                                      = var.common_tags
   nic_id                                    = local.filtered_network_interface_ids_observer
  
   depends_on                                = [module.create_linux_vms_observer]
 }


