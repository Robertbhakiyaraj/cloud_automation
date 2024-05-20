# Existing rg
data "azurerm_resource_group" "existing_rg" {
  name = var.vm_rg
}

# Existing vnet
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

#Existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name            
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name      
  resource_group_name  = var.vnet_rg
}

#Existing KeyVault
data "azurerm_key_vault" "existing_kv" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

#Existing Nic for MQ
 data "azurerm_network_interface" "existing_nic_mq" {
   count               = local.vm_count_mq
   name                = local.nic_names_mq[count.index]
   resource_group_name = local.resource_group_name_mq
   depends_on          = [module.create_linux_vms_mq]
 }

 #Extract the vm info for mq
 data "azurerm_virtual_machine" "vm_info_mq" {
  count                = local.vm_count_mq
  name                 = local.vm_names_mq[count.index]
  resource_group_name  = local.resource_group_name_mq
  depends_on           = [module.create_linux_vms_mq]
 }



#Extract the NIC info for subnet reserve ip
data "azurerm_network_interface" "mq_epp_nic_subnet_reserve_ip_info" {
  count               = var.floating_ip_count
  name                = "${var.nic_name_subnet_reserve_ip}-${count.index}"
  resource_group_name = var.vm_rg
  depends_on          = [resource.azurerm_network_interface.mq_epp_nic_subnet_reserve_ip]
}