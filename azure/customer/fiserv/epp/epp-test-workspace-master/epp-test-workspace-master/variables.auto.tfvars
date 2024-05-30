vnet_name                                            = ""
vnet_rg                                              = ""
subnet_name                                          = ""
vm_rg                                                = ""
vm_location                                          = ""
keyvault_name                                        = ""
keyvault_rg                                          = ""

app_name                                             = ""
env_name                                             = ""
apm_number                                           = ""
hostname_prefix                                      = ""


common_tags = {
    AppName                                          = ""
    Environment                                      = ""
    Owner                                            = ""
    UAID                                             = ""
    Build                                            = "Terraform"
}

disk_encryption_set_resource_group_name              = null
disk_encryption_set_name                             = null
customer_managed_key_name                            = null
managed_identity_ids                                 = [""]

#VM Configuration for Oracle
vm_specs_oracle = {
     laxoraclevm1 = {
        vm_size                                      = "Standard_E8ads_v5"
        vm_image                                     = ""
        os_storage_type                              = "Premium_LRS"
        os_disk_size                                 = "300"
        os_disk_caching                              = "ReadWrite"
        location                                     = ""
        zone                                         = "1"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""   
        disk_specs= [
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=500
            disk_caching="ReadOnly"
          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=50
            disk_caching="None"
          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=60
            disk_caching="ReadOnly"

          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=200
            disk_caching="None"
          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=70
            disk_caching="ReadOnly"
          }

        ]
    },
    laxoraclevm2 = {
        vm_size                                      = "Standard_E8ads_v5"
        vm_image                                     = ""
        os_storage_type                              = "Premium_LRS"
        os_disk_size                                 = "300"
        os_disk_caching                              = "ReadWrite"
        location                                     = ""
        zone                                         = "2"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = "" 
        disk_specs= [
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=500
            disk_caching="ReadOnly"
          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=50
            disk_caching="None"
          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=60
            disk_caching="ReadOnly"

          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=200
            disk_caching="None"
          },
          {
            disk_storage_types="Premium_LRS",
            disk_sizes_gb=70
            disk_caching="ReadOnly"
          }

        ]
    }     
}

#VM Configuration for Observer
vm_specs_observer = {    
    observer-0905 = {
        vm_size                                      = "Standard_E2as_v5"
        vm_image                                     = ""
        os_storage_type                              = "Premium_LRS"
        os_disk_size                                 = "350"
        os_disk_caching                              = "ReadWrite"
        location                                     = ""
        zone                                         = "3"
        resource_group                               = ""
        subnet_name                                  = ""
        admin_username                               = ""
        disk_specs= []
    }
}

#Security group for Oracle
network_security_group_spec_oracle ={
    lax-oracle-server-nsg = {
      security_group_name                            = "server-nsg"
      tags                                           = { resourceType = "server-nsg" }
      location                                       = ""
      attachment_type                                = "nic"
      security_rules = [
        {
          name                                       = "sr1"
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
          name                                       = "sr2"
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
        }                
      ]
    }
}
 
#Security group for Observer
network_security_group_spec_observer ={
    laxobserver-server-nsg = {
      security_group_name                            = "server-nsg"
      tags                                           = { resourceType = "observer-server-nsg" }
      location                                       = "Central US"
      attachment_type                                = "nic"
      security_rules = [
        {
          name                                       = "sr1"
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
          name                                       = "sr2"
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
        }              
      ]
    }
}
