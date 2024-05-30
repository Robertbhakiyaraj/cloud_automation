

# Create vm using shared module
module "cloud_vm" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/windowsvm/azurerm"
  version = "1.3.0"
  common_tags = {
    AppName     = "Orbo"
    Environment = "Lowers"
    APM         = "APM0006559"
    Build       = "Terraform"
  }
  use_existing_disk_encryption_set = true
  key_vault_id                     = var.keyvault_id
  key_vault_location               = var.vm_location
  join_to_domain                   = true
  active_directory_password        = data.azurerm_key_vault_secret.password.value
  active_directory_username        = data.azurerm_key_vault_secret.username.value
  active_directory_domain          = var.active_directory_domain
  ou_path                          = var.ou_path

  for_each = var.vm_specs
  availability_sets = {
    "availSet-${each.key}" = {
      name                         = "${var.app_name}-${var.env_name}-${each.key}-availset"
      resource_group_name          = var.vm_resourcegroup_name
      location                     = var.vm_location
      platform_update_domain_count = "5" ## externalize this
      platform_fault_domain_count  = "3" ## externalize this
      tags                         = { "availability_set_key" = "availSet-${each.key}-key" }
    }
  }

  vm_nics = {
    for n in range(1, lookup(var.vm_specs, each.key).instance_count + 1) : "nic${n}" => {
      name                               = "${var.hostname_prefix}${lower(lookup(var.vm_specs, each.key).naming_std)}${format("%04d", n)}-nic"
      subnet_id                          = var.subnet_map[lookup(var.vm_specs, each.key).subnet_name].subnet_details.subnet_id
      vnet_name                          = var.vnet_name
      networking_resource_group_name     = var.vnet_resourcegroup_name
      networking_resource_group_location = var.vm_location
      internal_dns_name_label            = null
      enable_ip_forwarding               = false
      enable_accelerated_networking      = true
      dns_servers                        = null
      appgw_backend_address_pool         = null
      associate_nic_to_appgw             = false
      associate_nic_to_lb                = false
      lb_backend_address_pool            = null

      nic_ip_configurations = [
        {
          static_ip = null
          name      = "ip-config-internal"
        }
      ]
      tags = { VM = "${var.hostname_prefix}${lower(lookup(var.vm_specs, each.key).naming_std)}${format("%04d", n)}" }
    }
  }

  virtual_machines = {
    for v in range(1, lookup(var.vm_specs, each.key).instance_count + 1) : "vm${v}" => {
      name                    = "${var.hostname_prefix}${lower(lookup(var.vm_specs, each.key).naming_std)}${format("%04d", v)}"
      computer_name           = "${upper(var.hostname_prefix)}${lower(lookup(var.vm_specs, each.key).naming_std)}${format("%04d", v)}"
      vm_resource_group_name  = var.vm_resourcegroup_name
      vm_location             = var.vm_location
      vm_size                 = lookup(var.vm_specs, each.key).vm_size
      # administrator_user_name = var.vm_local_admin
      zone                    = null
      assign_identity         = false
      managed_identity_ids    = ["var.managed_identity_ids"]
      availability_set_key    = "availSet-${each.key}"
      vm_nic_keys             = ["nic${v}"]
      storage_account_uri     = null
      source_image            = lookup(var.vm_specs, each.key).vm_image
      os_disk = {
        name                      = "${var.hostname_prefix}${lower(lookup(var.vm_specs, each.key).naming_std)}${format("%04d", v)}-os"
        caching                   = "None"
        storage_account_type      = lookup(var.vm_specs, each.key).os_storage_type
        disk_size_gb              = lookup(var.vm_specs, each.key).os_disk_size
        write_accelerator_enabled = false
      }
      tags = { vm = "${var.app_name}-${lower(lookup(var.vm_specs, each.key).naming_std)}" }
    }
  }

  managed_data_disks = {
    for d in range(1, lookup(var.vm_specs, each.key).instance_count + 1) : "disk${d}" => {
      name                      = "${var.hostname_prefix}${lower(lookup(var.vm_specs, each.key).naming_std)}${format("%04d", d)}-disk1"
      vm_key                    = "vm${d}"
      lun                       = 0
      storage_account_type      = lookup(var.vm_specs, each.key).data_storage_type
      disk_size_gb              = lookup(var.vm_specs, each.key).data_disk_gb
      caching                   = "None"
      zone                      = null
      create_option             = null
      os_type                   = null
      source_resource_id        = null
      write_accelerator_enabled = false
      max_shares                = 0
    }
  }
}