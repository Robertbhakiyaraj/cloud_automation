### Environment ###
env_subscription_id = ""

hostname_prefix = ""




### Network ###
net_stack = {
  net01 = {
    vnet_name_cus     = ""
    vnet_name_eus2    = ""
    vnet_rg_name_cus  = ""
    vnet_rg_name_eus2 = ""
    subnet_name_cus   = ""
    subnet_name_eus2  = ""
    subnet_cidr_cus   = "" # Need to change
    subnet_cidr_eus2  = "" 
    rt_name_cus       = "transit-rt"
    rt_name_eus2      = "transit-rt"
  }
}

### SQL ###
sql_stack = {
  sql01 = {
    environment = {
      app_name     = ""
      ou_path      = "" # "OU=<>,OU=<>,OU=<>,OU=<>,OU=<>,DC=<>,DC=<>,DC=com"
      ad_domain    = ""
      rg_name_cus  = ""
      rg_name_eus2 = ""
      sql_env      = ""
      tag_app_name = ""
      tag_env      = ""
      tag_owner    = ""
      tag_uaid     = "" # Need to change
    }
    identity = {
      mi_name_cus       = ""
      mi_name_eus2      = ""
      des_key_name_cus  = ""
      des_key_name_eus2 = ""
      des_name_cus      = ""
      des_name_eus2     = ""
    }
    keyvault = {
      kv_name_cus  = ""
      kv_name_eus2 = ""
    }
    load_balancer = {
      alb_name_cus           = ""
      alb_name_eus2          = ""
      alb_feip_name_cus      = ""
      alb_feip_name_eus2     = ""
      alb_bepool_name_cus    = ""
      alb_bepool_name_eus2   = ""
      alb_static_ip_cus      = "" # Need to change
      alb_static_ip_eus2     = "" # Need to change

    }
    vm_types = {
      pri = {
        instance_count      = 2
        naming_prefix       = ""
        vm_size             = "Standard_D8ads_v5"
        vm_image            = ""
        location            = ""
        naming_std          = ""
        os_storage_type     = "Premium_LRS"
        os_disk_size        = 128
        os_disk_caching     = "None"
        data_storage_type   = "Premium_LRS"
        data_disk_gb        = 768
        data_disk_caching   = "None"
        log_disk_gb         = 768
        log_disk_caching    = "None"
        backup_disk_gb      = 768
        backup_disk_caching = "None"
        program_disk_gb      = 128
        program_disk_caching = "None"
        tempdb_disk_gb         = 128
        tempdb_disk_caching    = "None"
      }
      sec = {
        instance_count      = 2
        naming_prefix       = ""
        vm_size             = "Standard_D8ads_v5"
        vm_image            = ""
        location            = ""
        naming_std          = ""
        os_storage_type     = "Premium_LRS"
        os_disk_size        = 128
        os_disk_caching     = "None"
        data_storage_type   = "Premium_LRS"
        data_disk_gb        = 768
        data_disk_caching   = "None"
        log_disk_gb         = 768
        log_disk_caching    = "None"
        backup_disk_gb      = 768
        backup_disk_caching = "None"
        program_disk_gb      = 128
        program_disk_caching = "None"
        tempdb_disk_gb         = 128
        tempdb_disk_caching    = "None"
      }
    }
  }
}
