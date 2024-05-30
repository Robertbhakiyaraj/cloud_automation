output "vm_info_mq" {
  value = {
    for vm in data.azurerm_virtual_machine.vm_info_mq : 
    vm.name => {
      id                  = vm.id
      location            = vm.location
      resource_group_name = vm.resource_group_name
      private_ip_address =  vm.private_ip_address 
    }
  }
}


output "floating_ip_details" {
  value = {
    for idx, nic in data.azurerm_network_interface.mq_epp_nic_subnet_reserve_ip_info : "${var.nic_name_subnet_reserve_ip}-${idx}" => {
      private_ip_address = nic.ip_configuration[0].private_ip_address
    }
  }
}