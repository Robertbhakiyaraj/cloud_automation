##### OCG - SQL DB #####

module "lb_sql01_eus2" {
  source                                 = "jlqpztfe01.onefiserv.net/fiserv-main/loadbalancer/azurerm"
  version                                = "1.1.1"
  resource_group_name                    = module.rg_sql01_eus2.name
  location                               = module.rg_sql01_eus2.location
  name                                   = var.sql_stack["sql01"].load_balancer.alb_name_eus2
  type                                   = "private"
  frontend_name                          = var.sql_stack["sql01"].load_balancer.alb_feip_name_eus2
  frontend_subnet_id                     = module.subnet_net01.subnet_id[0]
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = cidrhost(var.net_stack["net01"].subnet_cidr_eus2 , 4)
  lb_sku                                 = "Standard"
  enable_floating_ip                     = true
  backend_pool_name                      = var.sql_stack["sql01"].load_balancer.alb_bepool_name_eus2
  frontend_private_ip_availability_zones = ["1", "2", "3"]

  lb_port = {
    "ilb-bs-sqlagl-eus2" = ["1433", "Tcp", "1433"]
  }

  lb_probe = {
    "hp-ilb-sql01-eus2" = ["Tcp", "1433", ""]
  }

  tags = {
    source = "terraform"
  }
  depends_on = [
    module.rg_sql01_eus2
  ]
}

module "windowsvm_sql01_sec" {
  # count   = "${var.dr_deploy == "true" ? 1 : 0}"
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/windowsvm/azurerm"
  version = "1.3.0"
  common_tags = {
    AppName     = var.sql_stack["sql01"].environment.tag_app_name
    Environment = var.sql_stack["sql01"].environment.tag_env
    Owner       = var.sql_stack["sql01"].environment.tag_owner
    UAID        = var.sql_stack["sql01"].environment.tag_uaid
    Build       = "Terraform"
  }
  disk_encryption_set_managed_identity_ids = [azurerm_user_assigned_identity.id-sql01-eus2.id]
  disk_encryption_set_name                 = azurerm_disk_encryption_set.des_sql01_eus2.name
  disk_encryption_set_resource_group_name  = azurerm_disk_encryption_set.des_sql01_eus2.resource_group_name
  disk_encryption_set_id                   = azurerm_disk_encryption_set.des_sql01_eus2.id
  use_existing_disk_encryption_set         = true
  customer_managed_key_name                = azurerm_key_vault_key.des_key_sql01_eus2.name
  customer_managed_key_id                  = azurerm_key_vault_key.des_key_sql01_eus2.versionless_id
  key_vault_id                             = module.kv_sql01_eus2.key_vault.id
  key_vault_location                       = module.kv_sql01_eus2.key_vault.location
  join_to_domain                           = true
  active_directory_password                = data.azurerm_key_vault_secret.password.value
  active_directory_username                = data.azurerm_key_vault_secret.username.value
  active_directory_domain                  = var.sql_stack["sql01"].environment.ad_domain
  ou_path                                  = var.sql_stack["sql01"].environment.ou_path
  availability_sets = {
    as-key = {
      name                         = "avset-name"
      resource_group_name          = module.rg_sql01_eus2.name
      location                     = module.rg_sql01_eus2.location
      platform_update_domain_count = 3
      platform_fault_domain_count  = 3
      tags                         = { "availability_set_key" = "avset-tag" }
    }
  }
  # Create VMs
  virtual_machines = {
    for v in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) : "vm${v}" => {
      name                    = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", v)}"
      computer_name           = "${upper(var.sql_stack["sql01"].vm_types["sec"].naming_prefix)}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", v)}"
      vm_resource_group_name  = module.rg_sql01_eus2.name
      vm_location             = module.rg_sql01_eus2.location
      vm_size                 = var.sql_stack["sql01"].vm_types["sec"].vm_size
      # administrator_user_name = "localadmin"
      zone                    = (v % 2) + 1
      assign_identity         = false
      managed_identity_ids    = [azurerm_user_assigned_identity.id-sql01-eus2.id]
      availability_set_key    = null
      vm_nic_keys             = ["nic${v}"]
      storage_account_uri     = null
      source_image            = var.sql_stack["sql01"].vm_types["sec"].vm_image
      os_disk = {
        name                      = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", v)}-os"
        caching                   = var.sql_stack["sql01"].vm_types["sec"].os_disk_caching
        storage_account_type      = var.sql_stack["sql01"].vm_types["sec"].os_storage_type
        disk_size_gb              = var.sql_stack["sql01"].vm_types["sec"].os_disk_size
        write_accelerator_enabled = false
      }
      tags = { vm = "${var.sql_stack["sql01"].environment.app_name}-${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}" }
    }
  }
  # Create NICs
  vm_nics = {
    for n in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) : "nic${n}" => {
      name                               = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", n)}-nic"
      subnet_id                          = module.subnet_net01.subnet_id[0]
      vnet_name                          = data.azurerm_virtual_network.data_vnet_net01_eus2.name
      networking_resource_group_name     = module.rg_sql01_eus2.name
      networking_resource_group_location = module.rg_sql01_eus2.location
      internal_dns_name_label            = null
      enable_ip_forwarding               = false
      enable_accelerated_networking      = false
      dns_servers                        = null
      lb_backend_address_pool            = module.lb_sql01_eus2.lb_backend_address_pool_id
      associate_nic_to_lb                = true
      appgw_backend_address_pool         = null
      associate_nic_to_appgw             = false
      nic_ip_configurations = [
        {
          static_ip = null
          name      = "ip-config-internal"
        }
      ]
      tags = { VM = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", n)}" }
    }
  }
  # Create data disks (if required)
  managed_data_disks = merge({
    for d in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) :
    "disk1-${d}" => {
      name                      = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", d)}-data"
      vm_key                    = "vm${d}"
      lun                       = 0
      storage_account_type      = var.sql_stack["sql01"].vm_types["sec"].data_storage_type
      disk_size_gb              = var.sql_stack["sql01"].vm_types["sec"].data_disk_gb
      caching                   = var.sql_stack["sql01"].vm_types["sec"].data_disk_caching
      create_option             = null
      os_type                   = null
      source_resource_id        = null
      write_accelerator_enabled = false
      max_shares                = 0
    } },
    {
      for d in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) :
      "disk2-${d}" => {
        name                      = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", d)}-log"
        vm_key                    = "vm${d}"
        lun                       = 1
        storage_account_type      = var.sql_stack["sql01"].vm_types["sec"].data_storage_type
        disk_size_gb              = var.sql_stack["sql01"].vm_types["sec"].log_disk_gb
        caching                   = var.sql_stack["sql01"].vm_types["sec"].log_disk_caching
        create_option             = null
        os_type                   = null
        source_resource_id        = null
        write_accelerator_enabled = false
        max_shares                = 0
    } },
    {
      for d in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) :
      "disk3-${d}" => {
        name                      = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", d)}-backup"
        vm_key                    = "vm${d}"
        lun                       = 2
        storage_account_type      = var.sql_stack["sql01"].vm_types["sec"].data_storage_type
        disk_size_gb              = var.sql_stack["sql01"].vm_types["sec"].backup_disk_gb
        caching                   = var.sql_stack["sql01"].vm_types["sec"].backup_disk_caching
        create_option             = null
        os_type                   = null
        source_resource_id        = null
        write_accelerator_enabled = false
        max_shares                = 0
    } },
    {
      for d in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) :
      "disk4-${d}" => {
        name                      = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", d)}-program"
        vm_key                    = "vm${d}"
        lun                       = 3
        storage_account_type      = var.sql_stack["sql01"].vm_types["sec"].data_storage_type
        disk_size_gb              = var.sql_stack["sql01"].vm_types["sec"].program_disk_gb
        caching                   = var.sql_stack["sql01"].vm_types["sec"].program_disk_caching
        create_option             = null
        os_type                   = null
        source_resource_id        = null
        write_accelerator_enabled = false
        max_shares                = 0
    } },
    {
      for d in range(1, var.sql_stack["sql01"].vm_types["sec"].instance_count + 1) :
      "disk5-${d}" => {
        name                      = "${var.sql_stack["sql01"].vm_types["sec"].naming_prefix}${lower(var.sql_stack["sql01"].vm_types["sec"].naming_std)}${format("%02d", d)}-tempdb"
        vm_key                    = "vm${d}"
        lun                       = 4
        storage_account_type      = var.sql_stack["sql01"].vm_types["sec"].data_storage_type
        disk_size_gb              = var.sql_stack["sql01"].vm_types["sec"].tempdb_disk_gb
        caching                   = var.sql_stack["sql01"].vm_types["sec"].tempdb_disk_caching
        create_option             = null
        os_type                   = null
        source_resource_id        = null
        write_accelerator_enabled = false
        max_shares                = 0
      }
  })
  depends_on = [
    module.rg_sql01_eus2,
    azurerm_disk_encryption_set.des_sql01_eus2,
    module.lb_sql01_eus2,
    azurerm_key_vault_access_policy.ap-mi-sql01-kv-eus2
  ]
}