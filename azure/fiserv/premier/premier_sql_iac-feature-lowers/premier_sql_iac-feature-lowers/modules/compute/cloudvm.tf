
locals {
  vm_objects = flatten([
    for vm_type in var.vm_specs : [
      for i in range(vm_type.instance_count) : {
        hostname                                 = "${var.hostname_prefix}${vm_type.naming_std}${format("%04d", i)}"
        vm_size                                  = vm_type.vm_size
        vm_image                                 = vm_type.vm_image
        should_join_domain                       = vm_type.should_join_domain
        vm_type                                  = vm_type.naming_std
        os_disk_size                             = vm_type.os_disk_size
        os_storage_type                          = vm_type.os_storage_type
        os_disk_enable_acceleration              = vm_type.os_disk_enable_acceleration
        data_disks                               = vm_type.data_disks
        subnet_id                                = var.subnet_map[vm_type.subnet_name].subnet_details.subnet_id
        vnet_resourcegroup_name                  = var.vnet_resourcegroup_name
        app_name                                 = var.app_name
        availability_zone                        = (i % 3) + 1
        env_name                                 = var.env_name
        vnet_name                                = var.vnet_name
        disk_encryption_set_managed_identity_ids = var.disk_encryption_set_managed_identity_ids
        keyvault_id                              = var.keyvault_id
        key_vault_location                       = var.vm_location
        customer_managed_key_id                  = var.customer_managed_key_id
        customer_managed_key_name                = var.customer_managed_key_name
        disk_encryption_set_name                 = var.disk_encryption_set_name
        disk_encryption_set_id                   = var.disk_encryption_set_id
        managed_identity_name                    = var.managed_identity_name
        managed_identity_resource_group          = var.managed_identity_resource_group
        managed_identity_ids                     = var.managed_identity_ids
        vm_location                              = var.vm_location
        ou_path                                  = var.ou_path
        vm_local_admin                           = var.vm_local_admin
        active_directory_domain                  = var.active_directory_domain
        vm_resourcegroup_name                    = var.vm_resourcegroup_name
        associate_with_loadbalancer              = vm_type.associate_with_loadbalancer
        load_balancer_backend_pool_id            = vm_type.associate_with_loadbalancer ? var.load_balancer_backend_pool_id : null
      }
    ]
  ])
}

module "create_windowsvm" {
  source             = "./win_wrapper"
  
  for_each           = { for vmObj in local.vm_objects : vmObj.hostname => vmObj }
  hostname           = each.value["hostname"]
  vm_size            = each.value["vm_size"]
  vm_image           = each.value["vm_image"]
  should_join_domain = each.value["should_join_domain"]
  ##### vm_type                     = vm_type.naming_std #####
  os_disk_size                             = each.value["os_disk_size"]
  os_storage_type                          = each.value["os_storage_type"]
  os_disk_enable_acceleration              = each.value["os_disk_enable_acceleration"]
  data_disks                               = each.value["data_disks"]
  subnet_id                                = each.value["subnet_id"]
  vnet_resourcegroup_name                  = var.vnet_resourcegroup_name
  app_name                                 = each.value["app_name"]
  availability_zone                        = each.value["availability_zone"]
  env_name                                 = each.value["env_name"]
  vnet_name                                = each.value["vnet_name"]
  disk_encryption_set_managed_identity_ids = each.value["disk_encryption_set_managed_identity_ids"]
  keyvault_id                              = each.value["keyvault_id"]
  key_vault_location                       = each.value["vm_location"]
  customer_managed_key_id                  = each.value["customer_managed_key_id"]
  customer_managed_key_name                = each.value["customer_managed_key_name"]
  disk_encryption_set_name                 = each.value["disk_encryption_set_name"]
  disk_encryption_set_id                   = each.value["disk_encryption_set_id"]
  managed_identity_name                    = each.value["managed_identity_name"]
  managed_identity_resource_group          = each.value["managed_identity_resource_group"]
  managed_identity_ids                     = each.value["managed_identity_ids"]
  vm_location                              = each.value["vm_location"]
  ou_path                                  = each.value["ou_path"]
  vm_local_admin                           = each.value["vm_local_admin"]
  active_directory_domain                  = each.value["active_directory_domain"]
  vm_resourcegroup_name                    = each.value["vm_resourcegroup_name"]
  associate_with_loadbalancer              = each.value["associate_with_loadbalancer"]
  load_balancer_backend_pool_id            = each.value["load_balancer_backend_pool_id"]
}