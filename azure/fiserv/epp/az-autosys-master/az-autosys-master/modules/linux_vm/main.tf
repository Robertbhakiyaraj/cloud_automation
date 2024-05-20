module "create_linux_vms" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/linuxvm/azurerm"
  version = "v1.0.17"

  #Variable Definitions
  common_tags                                = var.common_tags 
  use_existing_disk_encryption_set           = false
  key_vault_location                         = var.vm_location
  key_vault_id                               = var.keyvault_id
  disk_encryption_set_resource_group_name    = var.disk_encryption_set_resource_group_name 
  disk_encryption_set_name                   = var.disk_encryption_set_name
  customer_managed_key_name                  = var.customer_managed_key_name
  enable_automatic_key_rotation              = true
  #disk_encryption_set_id                    = var.disk_encryption_set_id
  #disk_encryption_set_managed_identity_ids  = var.disk_encryption_set_managed_identity_ids
  #customer_managed_key_id                   = var.customer_managed_key_id

  #vm_nics Definition
  for_each = var.vm_specs
  vm_nics = {
  for n in range(1, 2) : "nic${n}" => {
      name                                   = "nic-${each.key}"
      subnet_id                              = var.subnet_id
      internal_dns_name_label                = null
      enable_ip_forwarding                   = false
      enable_accelerated_networking          = true
      dns_servers                            = null
      networking_resource_group_name         = var.vnet_rg
      networking_resource_group_location     = var.vm_location

      #nic_ip_configurations Definition 
      nic_ip_configurations = [
        {
          name                               = "nic-ipconfig-name-${each.key}"
          static_ip                          = null        }
      ]
      tags = { vm_nic                        = "vmnic-${each.key}" }
  }
}
  
  #virtual_machines Definition
  virtual_machines = {
  for v in range(1, 2) : "${each.key}" => {
    name                                     = "${each.key}"
    vm_resource_group_name                   = var.vm_rg
    vm_location                              = var.vm_location
    vm_size                                  = lookup(var.vm_specs, each.key).vm_size
    administrator_user_name                  = lookup(var.vm_specs, each.key).admin_username
    zone                                     = lookup(var.vm_specs, each.key).zone
    assign_identity                          = false
    managed_identity_ids                     = var.managed_identity_ids
    availability_set_key                     = null
    vm_nic_keys                              = ["nic${v}"]
    storage_account_uri                      = null
    source_image                             = lookup(var.vm_specs, each.key).vm_image
    #custom_data                             = var.custom_data

    #os_disk Definition
    os_disk = {
      name                                   = "osDisk-${each.key}"
      caching                                = lookup(var.vm_specs, each.key).os_disk_caching
      storage_account_type                   = lookup(var.vm_specs, each.key).os_storage_type
      disk_size_gb                           = lookup(var.vm_specs, each.key).os_disk_size
      write_accelerator_enabled              = false
    }
    tags = { vm                              = "${each.key}" }
  }
}

#managed_data_disks Definition
managed_data_disks = {
  for d , disk in var.vm_specs[each.key].disk_specs : "disk${d+1}" => {
      name                                   = "disk-${each.key}-disk${d+1}"
      vm_key                                 = "${each.key}"
      lun                                    = d
      storage_account_type                   = disk.disk_storage_types
      disk_size_gb                           = disk.disk_sizes_gb
      caching                                = disk.disk_caching
      write_accelerator_enabled              = false
      create_option                          = null
      os_type                                = null
      source_resource_id                     = null
  }
}
}

