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
 data "azurerm_network_interface" "existing_nic_autosys" {
   count               = local.vm_count_autosys
   name                = local.nic_names_autosys[count.index]
   resource_group_name = local.resource_group_name_autosys
   depends_on          = [module.create_linux_vms_autosys]
 }

#Extract the vm info for autosys
 data "azurerm_virtual_machine" "vm_info_autosys" {
  count                = local.vm_count_autosys
  name                 = local.vm_names_autosys[count.index]
  resource_group_name  = local.resource_group_name_autosys
  depends_on           = [module.create_linux_vms_autosys]
 }

