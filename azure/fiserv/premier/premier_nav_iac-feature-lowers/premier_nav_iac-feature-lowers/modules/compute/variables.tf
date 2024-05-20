variable "active_directory_domain" {
  type = string
}
variable "managed_identity_ids" {
  type = string
}
variable "ou_path" {
  type = string
}
variable "vm_local_admin" {
  type    = string
  default = "fiserv"
}

variable "vm_specs" {
  type = map(object({
    instance_count              = number
    vm_size                     = string
    vm_image                    = string
    naming_std                  = string
    os_storage_type             = string
    os_disk_size                = number
    os_disk_enable_acceleration = bool
    data_disks = optional(list(object({
      name                = string
      size                = string
      storage_type        = string
      enable_acceleration = bool
    })), [])
    subnet_name                 = string
    associate_with_loadbalancer = optional(bool, false)
  }))
}

variable "load_balancer_backend_pool_id" {
  type    = string
  default = null
}

variable "vnet_name" {
  type = string
}

variable "subnet_map" {
  type = map(any)
}

variable "vnet_resourcegroup_name" {
  type = string
}

variable "vm_resourcegroup_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "env_name" {
  type = string
}

variable "apm_number" {
  type = string
}

variable "managed_identity_name" {
  type = string
}

variable "keyvault_id" {
  type = string
}

variable "hostname_prefix" {
  type = string
}

variable "vm_location" {
  type = string
}

variable "default_route_table_name" {
  type        = string
  default     = "transit-rt"
  description = "Default Transit route table"
}

variable "disk_encryption_set_managed_identity_ids" {
  type = list(string)
}

variable "disk_encryption_set_name" {
  type = string
}


variable "disk_encryption_set_id" {
  type = string
}

variable "customer_managed_key_name" {
  type = string
}

variable "customer_managed_key_id" {
  type = string
}

variable "user_assigned_id" {
  default = ""
}


variable "managed_identity_resource_group" {
  type = string
}

variable "should_join_domain" {
  type = bool 
  default = true
}
