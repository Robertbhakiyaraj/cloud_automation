#vnet,subnet,keyvault,rg & location Details
vnet_name                                            = "" 
vnet_rg                                              = ""
subnet_name                                          = ""
vm_rg                                                = ""
vm_location                                          = ""
keyvault_name                                        = ""
keyvault_rg                                          = ""

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

#VM Configuration for autosys
vm_specs_autosys = {
    #AutoSys Agent - VM name should not have more than 16 characters 
    lowerautovm110 = {
        vm_size                                      = ""
        vm_image                                     = ""
        os_storage_type                              = ""
        os_disk_size                                 = ""
        os_disk_caching                              = ""
        location                                     = ""
        zone                                         = "1"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""  
        disk_specs                                   = [] 
    },
    #AutoSys Agent- VM name should not have more than 16 characters
    lowerautovm210 = {
        vm_size                                      = ""
        vm_image                                     = ""
        os_storage_type                              = ""
        os_disk_size                                 = ""
        os_disk_caching                              = ""
        location                                     = ""
        zone                                         = ""
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""  
        disk_specs                                   = []  
    }      
}


#Security group for Autosys and Control-M
network_security_group_spec_autosys ={
    autosys-server-nsg = {
      security_group_name                            = ""
      tags                                           = { resourceType = "nsg" }
      location                                       = ""
      attachment_type                                = "nic"
      security_rules = [
        {
          name                                       = ""
          description                                = "NSG"
          priority                                   = 101
          direction                                  = "Inbound"
          access                                     = "Allow"
          protocol                                   = "Tcp"
          source_port_range                          = "*"
          source_port_ranges                         = null
          destination_port_range                     = null
          destination_port_ranges                    = []
          source_address_prefix                      = "*"
          source_address_prefixes                    = null
          destination_address_prefix                 = "*"
          destination_address_prefixes               = null
          source_application_security_group_ids      = null
          destination_application_security_group_ids = null
        },
        {
          name                                       = ""
          description                                = "NSG"
          priority                                   = 102
          direction                                  = "Inbound"
          access                                     = "Allow"
          protocol                                   = "Tcp"
          source_port_range                          = "*"
          source_port_ranges                         = null
          destination_port_range                     = "22"
          destination_port_ranges                    = null
          source_address_prefix                      = null
          source_address_prefixes                    = []
          destination_address_prefix                 = "*"
          destination_address_prefixes               = null
          source_application_security_group_ids      = null
          destination_application_security_group_ids = null
        },
        {
          name                                       = ""
          description                                = "NSG"
          priority                                   = 101
          direction                                  = "Outbound"
          access                                     = "Allow"
          protocol                                   = "Tcp"
          source_port_range                          = "*"
          source_port_ranges                         = null
          destination_port_range                     = null
          destination_port_ranges                    = []
          source_address_prefix                      = "*"
          source_address_prefixes                    = null
          destination_address_prefix                 = "*"
          destination_address_prefixes               = null
          source_application_security_group_ids      = null
          destination_application_security_group_ids = null
        }
      ]
    }
}
 
