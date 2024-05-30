subscription_id          = ""
vnet_name                = ""
vnet_resourcegroup_name  = ""
default_route_table_name = "transit-rt"

app_name   = ""
env_name   = ""
apm_number = ""


should_join_domain = true   ## Temporary
ou_path                   ="" # "OU=<>,OU=<>,OU=<>,OU=<>,OU=<>,DC=<>,DC=<>,DC=com" 
active_directory_domain   = "" 
active_directory_username = ""
active_directory_password = ""
vm_local_admin            = ""

cloudapp_subnets_cidrs_map = {
  "filestore"  = ""
  "web"        = ""
  "service"    = ""
  "appgateway" = ""
  "keyvault"   = ""
}

hostname_prefix = ""

vm_specs = {
  WEB = {
    instance_count              = 2
    vm_size                     = "Standard_D4ds_v5"
    vm_image                    = ""
    naming_std                  = ""
    os_storage_type             = "Premium_LRS"
    os_disk_size                = 220
    subnet_name                 = ""
    os_disk_enable_acceleration = false
    associate_with_loadbalancer = true
    data_disks  = [
      {
      name                = "disk1"
      size                =  "100"
      storage_type        =  "Premium_LRS"
      enable_acceleration =  false
      }
    ]
  }
  SOA = {
    instance_count              = 2
    vm_size                     = "Standard_D4ds_v5"
    vm_image                    = ""
    naming_std                  = ""
    os_storage_type             = "Premium_LRS"
    os_disk_size                = 220
    subnet_name                 = ""
    os_disk_enable_acceleration = false
    associate_with_loadbalancer = true
    data_disks  = [
      {
        name                = "disk1"
      size                =  "120"
      storage_type        =  "Premium_LRS"
      enable_acceleration =  false
      }
    ]
  }
  ASP = {
    instance_count              = 2
    vm_size                     = "Standard_D4ds_v5"
    vm_image                    = ""
    naming_std                  = ""
    os_storage_type             = "Premium_LRS"
    os_disk_size                = 220
    subnet_name                 = ""
    os_disk_enable_acceleration = false
  }
  UI = {
    instance_count              = 2
    vm_size                     = "Standard_D4ds_v5"
    vm_image                    = ""
    naming_std                  = ""
    os_storage_type             = "Premium_LRS"
    os_disk_size                = 220
    subnet_name                 = ""
    os_disk_enable_acceleration = false
    associate_with_loadbalancer = true
    data_disks  = [
      {
      name                = "disk1"
      size                =  "100"
      storage_type        =  "Premium_LRS"
      enable_acceleration =  false
      }
    ]
  }
}

