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
 data "azurerm_network_interface" "existing_nic_oracle" {
   count               = local.vm_count_oracle
   name                = local.nic_names_oracle[count.index]
   resource_group_name = local.resource_group_name_oracle
   depends_on          = [module.create_linux_vms_oracle]
 }

#Existing Nic for Jump
 data "azurerm_network_interface" "existing_nic_observer" {
   count               = local.vm_count_observer
   name                = local.nic_names_observer[count.index]
   resource_group_name = local.resource_group_name_observer
   depends_on          = [module.create_linux_vms_observer]
 }

#Extract the vm info for oracle
 data "azurerm_virtual_machine" "vm_info_oracle" {
  count                = local.vm_count_oracle
  name                 = local.vm_names_oracle[count.index]
  resource_group_name  = local.resource_group_name_oracle
  depends_on          = [module.create_linux_vms_oracle]
 }

#Extract the vm info for observer
 data "azurerm_virtual_machine" "vm_info_observer" {
  count                = local.vm_count_observer
  name                 = local.vm_names_observer[count.index]
  resource_group_name  = local.resource_group_name_observer
  depends_on          = [module.create_linux_vms_observer]
 }
