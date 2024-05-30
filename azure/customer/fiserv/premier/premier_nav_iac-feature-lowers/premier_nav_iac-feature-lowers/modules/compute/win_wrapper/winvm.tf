

# Create Windows VM using shared module
module "winvm" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/windowsvm/azurerm"
  version = "1.3.0"

  common_tags = {
    AppName     = var.app_name
    Environment = var.env_name
    Build       = "Terraform"
  }

  use_existing_disk_encryption_set = true
  key_vault_id                     = var.keyvault_id
  key_vault_location               = var.vm_location
  customer_managed_key_id          = var.customer_managed_key_id
  customer_managed_key_name        = var.customer_managed_key_name
  disk_encryption_set_name         = var.disk_encryption_set_name
  disk_encryption_set_id           = var.disk_encryption_set_id
  disk_encryption_set_managed_identity_ids = var.disk_encryption_set_managed_identity_ids
  join_to_domain                   = var.should_join_domain
  active_directory_password        = data.azurerm_key_vault_secret.password.value
  active_directory_username        = data.azurerm_key_vault_secret.username.value
  active_directory_domain          = var.active_directory_domain
  ou_path                          = var.ou_path

  vm_nics = {
    NIC0 = {
      name                               = "${var.hostname}-nic"
      subnet_id                          = var.subnet_id
      vnet_name                          = var.vnet_name
      networking_resource_group_name     = var.vnet_resourcegroup_name
      networking_resource_group_location = var.vm_location
      internal_dns_name_label            = null
      enable_ip_forwarding               = false
      enable_accelerated_networking      = true
      dns_servers                        = null
      appgw_backend_address_pool         = null
      associate_nic_to_appgw             = false
      associate_nic_to_lb                = var.associate_with_loadbalancer
      lb_backend_address_pool            = var.load_balancer_backend_pool_id

      nic_ip_configurations = [
        {
          static_ip = null
          name      = "ip-config-internal"
        }
      ]
      tags = { VM = var.hostname }
    }
  }

  virtual_machines = {
    vm0 = {
      name                   = var.hostname
      computer_name          = upper(var.hostname)
      vm_resource_group_name = var.vm_resourcegroup_name
      vm_location            = var.vm_location
      vm_size                = var.vm_size
      #administrator_user_name = var.vm_local_admin
      zone                 = var.availability_zone
      assign_identity      = false
      managed_identity_ids = [var.managed_identity_ids]
      managed_identity_name   = var.managed_identity_name
      availability_set_key = null
      vm_nic_keys          = ["NIC0"]
      storage_account_uri  = null
      source_image         = var.vm_image
      # custom_data    =     filebase64("${path.module}/winrm/SetWinRMCert.ps1")
      os_disk = {
        name                      = "${var.hostname}-os"
        caching                   = "None"
        storage_account_type      = var.os_storage_type
        disk_size_gb              = var.os_disk_size
        write_accelerator_enabled = var.os_disk_enable_acceleration
      }
      tags = { vm = var.hostname }
    }
  }
  managed_data_disks = {
    for Idx, d in range(1, length(var.data_disks) > 0 ? length(var.data_disks) + 1 : 0) : "disk${d}" => {
      name                      = "${var.hostname}-${var.data_disks[Idx].name}"
      vm_key                    = "vm0"
      lun                       = 1 + Idx
      storage_account_type      = var.data_disks[Idx].storage_type
      disk_size_gb              = coalesce(var.data_disks[Idx].size, "64")
      caching                   = "None"
      zone                      = null
      create_option             = "Empty"
      os_type                   = null
      source_resource_id        = null
      write_accelerator_enabled = var.data_disks[Idx].enable_acceleration
      max_shares                = 0
    }
    if length(var.data_disks) > 0
  }
}

resource "azurerm_virtual_machine_extension" "WinRM_Installer" {
  name                 = "install-winrm"
  virtual_machine_id   = module.winvm.vm_ids[0]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.winrm_script.rendered)}')) | Out-File -filepath winrm.ps1\" && powershell -ExecutionPolicy Unrestricted -File winrm.ps1"
    }
    SETTINGS

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  # Adding these to make sure all the infrastructure is installed
  depends_on = [
    module.winvm,
  ]
}
