locals {
  vm_count_mq                  = length(var.vm_specs_mq)
  nic_names_mq                 = [for vm_name, _ in var.vm_specs_mq : "${var.hostname_prefix}-${var.app_name}-${var.env_name}-nic-${vm_name}"]
  vm_names_mq                  = [for vm_name, _ in var.vm_specs_mq : "${var.hostname_prefix}-${var.app_name}-${var.env_name}-${vm_name}"]     
  resource_group_name_mq       = var.vm_rg

}

locals {
  filtered_network_interface_ids_mq   = [for nic in data.azurerm_network_interface.existing_nic_mq : nic.id ]
}


