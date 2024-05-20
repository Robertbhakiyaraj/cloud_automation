# Create Linux VM for MQ 
module "create_linux_vms_mq" {
  source = "./modules/linux_vm"

  app_name                                   = var.app_name
  env_name                                   = var.env_name
  apm_number                                 = var.apm_number
  hostname_prefix                            = var.hostname_prefix

  vm_specs                                   = var.vm_specs_mq
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

  depends_on = [ resource.azurerm_network_interface.mq_epp_nic_subnet_reserve_ip]

}



# Create SG for MQ
 module "create_network_security_group_mq" {
   source = "./modules/security_group"

   app_name                                  = var.app_name
   env_name                                  = var.env_name
   apm_number                                = var.apm_number
   hostname_prefix                           = var.hostname_prefix

   vm_rg                                     = var.vm_rg
   network_security_group_spec               = var.network_security_group_spec_mq
   nsg_resource_group_name                   = var.vnet_rg
   nsg_subnet_name                           = data.azurerm_subnet.existing_subnet.name
   nsg_vnet_name                             = var.vnet_name   

   environment                               = var.env_name
   tags                                      = var.common_tags
   nic_id                                    = local.filtered_network_interface_ids_mq

   depends_on                                = [module.create_linux_vms_mq]
 }

resource "azurerm_network_interface" "mq_epp_nic_subnet_reserve_ip" {
  count               = var.floating_ip_count
  name                = "${var.nic_name_subnet_reserve_ip}-${count.index}"
  location            = var.vm_location
  resource_group_name = var.vm_rg
 
  ip_configuration {
    name                          = "${var.nic_config_name_subnet_reserve_ip}-${count.index}"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_addresses[count.index]
  }
}