# Create Linux VM for AutoSys
module "create_linux_vms_autosys" {
  source = "./modules/linux_vm"

  app_name                                   = var.app_name
  env_name                                   = var.env_name
  apm_number                                 = var.apm_number
  hostname_prefix                            = var.hostname_prefix

  vm_specs                                   = var.vm_specs_autosys
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

}


# Create SG for AutoSys
 module "create_network_security_group_autosys" {
   source = "./modules/security_group"

   app_name                                  = var.app_name
   env_name                                  = var.env_name
   apm_number                                = var.apm_number
   hostname_prefix                           = var.hostname_prefix

   vm_rg                                     = var.vm_rg
   network_security_group_spec               = var.network_security_group_spec_autosys
   nsg_resource_group_name                   = var.vnet_rg
   nsg_subnet_name                           = data.azurerm_subnet.existing_subnet.name
   nsg_vnet_name                             = var.vnet_name   

   environment                               = var.env_name
   tags                                      = var.common_tags
   nic_id                                    = local.filtered_network_interface_ids_autosys

   depends_on                                = [module.create_linux_vms_autosys]
 }


