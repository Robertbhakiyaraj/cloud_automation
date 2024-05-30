output "vm_info_autosys" {
  value = {
    for vm in data.azurerm_virtual_machine.vm_info_autosys : 
    vm.name => {
      id                  = vm.id
      location            = vm.location
      resource_group_name = vm.resource_group_name
      private_ip_address =  vm.private_ip_address 
    }
  }
}