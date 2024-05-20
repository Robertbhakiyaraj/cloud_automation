subscription_id          = ""
vnet_name                = ""
vnet_resourcegroup_name  = ""
default_route_table_name = "transit-rt"

app_name   = ""
env_name   = ""
apm_number = ""


ou_path                   = "" # "OU=<>,OU=<>,OU=<>,OU=<>,OU=<>,DC=<>,DC=<>,DC=com"
active_directory_domain   = ""
active_directory_username = ""
active_directory_password = ""

clouddb_subnets_cidrs_map = {
  "db" = ""
}

azure_entra_group_id  = ""
azure_entra_object_id = ""

hostname_prefix = ""

vm_specs = {
  SQL = {
    instance_count              = 2
    vm_size                     = "Standard_D8ds_v5"
    vm_image                    = ""
    naming_std                  = "sql"
    os_storage_type             = "Premium_LRS"
    os_disk_size                = 220
    subnet_name                 = "db"
    os_disk_enable_acceleration = false
    associate_with_loadbalancer = true
    should_join_domain          = true
    data_disks = [
      {
        name                = "disk1"
        size                = "120"
        storage_type        = "Premium_LRS"
        enable_acceleration = false
      }
    ]
  }
}
