variable "list_of_vms" {
  type    = list(any)
  default = null
}

variable "load_balancer_backend_pool_id" {
  type    = string
  default = null
}

variable "should_join_domain" {
  type    = bool
  default = true
}

variable "active_directory_domain" {
  type = string
}

variable "app_name" {
  type = string
}


variable "associate_with_loadbalancer" {
  type = string
}


variable "availability_zone" {
  type = number
}


variable "customer_managed_key_id" {
  type = string
}


variable "customer_managed_key_name" {
  type = string
}


variable "data_disks" {
  type = list(object({
    name                = string
    size                = string
    storage_type        = string
    enable_acceleration = bool
  }))
  default = []
}


variable "disk_encryption_set_id" {
  type = string
}


variable "disk_encryption_set_managed_identity_ids" {
  type = list(string)
}


variable "disk_encryption_set_name" {
  type = string
}


variable "env_name" {
  type = string
}


variable "key_vault_location" {
  type = string
}


variable "keyvault_id" {
  type = string
}


variable "managed_identity_ids" {
  type = string
}


variable "managed_identity_name" {
  type = string
}


variable "managed_identity_resource_group" {
  type = string
}


variable "os_disk_enable_acceleration" {
  type = string
}


variable "os_disk_size" {
  type = string
}


variable "os_storage_type" {
  type = string
}


variable "ou_path" {
  type = string
}


variable "subnet_id" {
  type = string
}


variable "vm_image" {
  type = string
}


variable "vm_local_admin" {
  type = string
}


variable "vm_location" {
  type = string
}


variable "vm_resourcegroup_name" {
  type = string
}


variable "vm_size" {
  type = string
}


variable "vnet_name" {
  type = string
}


variable "vnet_resourcegroup_name" {
  type = string
}


variable "hostname" {
  type = string
}
