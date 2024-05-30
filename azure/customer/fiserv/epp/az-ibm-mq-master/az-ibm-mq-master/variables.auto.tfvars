#vnet,subnet,keyvault,rg & location Details
vnet_name                                            = ""
vnet_rg                                              = ""
subnet_name                                          = ""
vm_rg                                                = ""
vm_location                                          = ""
keyvault_name                                        = ""
keyvault_rg                                          = ""


#Floating IP Details
floating_ip_count                                    =  3
private_ip_addresses                                 =  []
nic_name_subnet_reserve_ip                           = ""
nic_config_name_subnet_reserve_ip                    = ""

#Common Details
app_name                                             = ""
env_name                                             = ""
apm_number                                           = ""
hostname_prefix                                      = ""

common_tags = {
    AppName                                          = ""
    Environment                                      = ""      
    Owner                                            = "" 
    UAID                                             = "" 
    Build                                            = ""
}

#Disk Encryption Details 
disk_encryption_set_resource_group_name              = null
disk_encryption_set_name                             = null
customer_managed_key_name                            = null
managed_identity_ids                                 = [""]

#VM Configuration for MQ
vm_specs_mq = {
    vm1-0905 = {
        vm_size                                      = "Standard_D4as_v4"
        vm_image                                     = ""
        os_storage_type                              = "Premium_LRS"
        os_disk_size                                 = "300"
        os_disk_caching                              = "ReadWrite"
        location                                     = ""
        zone                                         = "1"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""
        disk_specs = [
        {
          disk_storage_types="Premium_LRS",
          disk_sizes_gb=210
          disk_caching="ReadWrite"
        }
        ]   
    },
    vm2-0905 = {
        vm_size                                      = "Standard_D4as_v4"
        vm_image                                     = ""
        os_storage_type                              = "Premium_LRS"
        os_disk_size                                 = "300"
        os_disk_caching                              = "ReadWrite"
        location                                     = ""
        zone                                         = "2"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""   
        disk_specs = [
        {
          disk_storage_types="Premium_LRS",
          disk_sizes_gb=210
          disk_caching="ReadWrite"
        }
        ]        
    },
    vm3-0905 = {
        vm_size                                      = "Standard_D4as_v4"
        vm_image                                     = ""
        os_storage_type                              = "Premium_LRS"
        os_disk_size                                 = "300"
        os_disk_caching                              = "ReadWrite"
        location                                     = ""
        zone                                         = "3"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""
        disk_specs = [
        {
          disk_storage_types="Premium_LRS",
          disk_sizes_gb=210
          disk_caching="ReadWrite"
        }
        ] 
    }        
}

#Security group for MQ
network_security_group_spec_mq ={
    mq-server-nsg = {
      security_group_name                            = "mq-server-nsg"
      tags                                           = { resourceType = "mq-server-nsg" }
      location                                       = "Central US"
      attachment_type                                = "nic"
      security_rules = [
        {
          name                                       = "mq-sr1"
          description                                = "NSG"
          priority                                   = 101
          direction                                  = "Outbound"
          access                                     = "Allow"
          protocol                                   = "Tcp"
          source_port_range                          = "*"
          source_port_ranges                         = null
          destination_port_range                     = null
          destination_port_ranges                    = [""]
          source_address_prefix                      = "*"
          source_address_prefixes                    = null
          destination_address_prefix                 = "*"
          destination_address_prefixes               = null
          source_application_security_group_ids      = null
          destination_application_security_group_ids = null
        },
        {
          name                                       = "mq-sr2"
          description                                = "NSG"
          priority                                   = 102
          direction                                  = "Inbound"
          access                                     = "Allow"
          protocol                                   = "Tcp"
          source_port_range                          = "*"
          source_port_ranges                         = null
          destination_port_range                     = null
          destination_port_ranges                    = [""]
          source_address_prefix                      = "*"
          source_address_prefixes                    = null
          destination_address_prefix                 = "*"
          destination_address_prefixes               = null
          source_application_security_group_ids      = null
          destination_application_security_group_ids = null
        },
        {
          name                                       = "mq-sr3"
          description                                = "NSG"
          priority                                   = 103
          direction                                  = "Inbound"
          access                                     = "Allow"
          protocol                                   = "Tcp"
          source_port_range                          = "*"
          source_port_ranges                         = null
          destination_port_range                     = "22"
          destination_port_ranges                    = null
          source_address_prefix                      = null
          source_address_prefixes                    = [""]
          destination_address_prefix                 = "*"
          destination_address_prefixes               = null
          source_application_security_group_ids      = null
          destination_application_security_group_ids = null
        }              
      ]
    }
}
