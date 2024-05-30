locals {
  vm_count_oracle                  = length(var.vm_specs_oracle)
  nic_names_oracle                 = [for vm_name, _ in var.vm_specs_oracle : "${var.hostname_prefix}-${var.app_name}-${var.env_name}-nic-${vm_name}"]
  vm_names_oracle                  = [for vm_name, _ in var.vm_specs_oracle : "${var.hostname_prefix}-${var.app_name}-${var.env_name}-${vm_name}"]     
  resource_group_name_oracle       = var.vm_rg
}

locals {
  vm_count_observer                 = length(var.vm_specs_observer)
  nic_names_observer                = [for vm_name, _ in var.vm_specs_observer : "${var.hostname_prefix}-${var.app_name}-${var.env_name}-nic-${vm_name}"]
  vm_names_observer                 = [for vm_name, _ in var.vm_specs_observer : "${var.hostname_prefix}-${var.app_name}-${var.env_name}-${vm_name}"]
  resource_group_name_observer      = var.vm_rg
}


locals {
  filtered_network_interface_ids_oracle   = [for nic in data.azurerm_network_interface.existing_nic_oracle : nic.id ]
  filtered_network_interface_ids_observer = [for nic in data.azurerm_network_interface.existing_nic_observer : nic.id ]
}


