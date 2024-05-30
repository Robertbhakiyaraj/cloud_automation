### Environment ###
variable "client_id_privateDNS" {}
variable "client_secret_privateDNS" {}
variable "subscription_id_kvPrivateDNS" {}

variable "env_subscription_id" {
  description = "Azure Subscription ID"
}


variable "hostname_prefix" {
  type = string
}

### Network ###
variable "net_stack" {
  type = map(object({
    vnet_name_cus     = string
    vnet_name_eus2    = string
    vnet_rg_name_cus  = string
    vnet_rg_name_eus2 = string
    subnet_name_cus   = string
    subnet_name_eus2  = string
    subnet_cidr_cus   = string
    subnet_cidr_eus2  = string
    rt_name_cus       = string
    rt_name_eus2      = string
  }))
}

### SQL ###
variable "sql_stack" {
  type = map(object({
    environment = object({
      app_name     = string
      ou_path      = string
      ad_domain    = string
      rg_name_cus  = string
      rg_name_eus2 = string
      sql_env      = string
      tag_app_name = string
      tag_env      = string
      tag_owner    = string
      tag_uaid     = string
    })
    identity = object({
      mi_name_cus       = string
      mi_name_eus2      = string
      des_key_name_cus  = string
      des_key_name_eus2 = string
      des_name_cus      = string
      des_name_eus2     = string
    })
    keyvault = object({
      kv_name_cus  = string
      kv_name_eus2 = string
    })
    load_balancer = object({
      alb_name_cus           = string
      alb_name_eus2          = string
      alb_feip_name_cus      = string
      alb_feip_name_eus2     = string
      alb_bepool_name_cus    = string
      alb_bepool_name_eus2   = string
      alb_static_ip_cus      = string
    })
    vm_types = map(object({
      instance_count      = number
      naming_prefix       = string
      vm_size             = string
      vm_image            = string
      location            = string
      naming_std          = string
      os_storage_type     = string
      os_disk_size        = number
      os_disk_caching     = string
      data_storage_type   = string
      data_disk_gb        = number
      data_disk_caching   = string
      log_disk_gb         = number
      log_disk_caching    = string
      backup_disk_gb      = number
      backup_disk_caching = string
      program_disk_gb      = number
      program_disk_caching = string
      tempdb_disk_gb         = number
      tempdb_disk_caching    = string
    }))
  }))
}