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
  type = string
}

variable "vm_specs" {
  type = map(any)
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
