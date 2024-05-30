# Global variables
variable "subscription_id" {
  type        = string
}

variable "app_name" {
  type        = string
}

variable "env_name" {
  type        = string
  default     = ""
  description = "Name of the environment ( lowers , cert , prod , dr )"
}


# Network stack variables

variable "vnet_name" {
  type        = string
}

variable "vnet_resourcegroup_name" {
  type        = string
}

variable "hostname_prefix" {
    type = string
}


variable "apm_number" {
  type        = string
}

variable "client_id_privateDNS" {
  default = ""
}
variable "client_secret_privateDNS" {
  default = ""
}
variable "subscription_id_kvPrivateDNS" {
  default = ""
}

variable "keyvault_rg" {
  type = string
}

variable "storage_rg" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "storage_account_specs_db" {
   type = map(any)
}

variable "storage_account_specs_apps" {
   type = map(any)
}

variable "file_share_specs" {
  type = map(any)
}

variable "storage_account_bring_cmk" {
  type=string
}

variable "containers_specs" {
  type = map(any)
}

variable "blobs_specs" {
  type = map(any)
}
