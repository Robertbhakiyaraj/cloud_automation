locals {
  vm_count_autosys                  = length(var.vm_specs_autosys)
  nic_names_autosys                 = [for vm_name, _ in var.vm_specs_autosys : "nic-${vm_name}"]
  vm_names_autosys                  = [for vm_name, _ in var.vm_specs_autosys : "${vm_name}"]       
  resource_group_name_autosys       = var.vm_rg
}

locals {
  filtered_network_interface_ids_autosys   = [for nic in data.azurerm_network_interface.existing_nic_autosys : nic.id ]
}


