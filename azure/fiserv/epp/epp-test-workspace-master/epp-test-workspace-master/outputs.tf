# Output for Oracle VM Info
output "vm_info_oracle" {
  value = {
    for vm in data.azurerm_virtual_machine.vm_info_oracle : 
    vm.name => {
      id                  = vm.id
      location            = vm.location
      resource_group_name = vm.resource_group_name
      private_ip_address =  vm.private_ip_address 
    }
  }
}

# Output for Observer VM Info
output "vm_info_observer" {
  value = {
    for vm in data.azurerm_virtual_machine.vm_info_observer : 
    vm.name => {
      id                  = vm.id
      location            = vm.location
      resource_group_name = vm.resource_group_name
      private_ip_address =  vm.private_ip_address     
    }
  }
}