# Global variables
variable "subscription_id" {
  type        = string
  default     = ""
  description = "Premier Navigator Lowers Subscription ID"

}

variable "app_name" {
  type        = string
  default     = "nav"
  description = "The app Short name"
}

variable "env_name" {
  type        = string
  default     = ""
  description = "Name of the environment ( lowers , cert , prod , dr )"
}

variable "location" {
  description = "The location in which the resources will be created."
  default     = "eastus2"
  type        = string
}

# Network stack variables

variable "vnet_name" {
  type        = string
  description = "Premier Navigator  Development Virtual Network Name"
}

variable "vnet_resourcegroup_name" {
  type        = string
  description = "Premier Navigator Development Virtual Network Resource Group name"

}

variable "default_route_table_name" {
  type        = string
  default     = "transit-rt"
  description = "Default Transit route table"
}


variable "clouddb_subnets_cidrs_map" {
  type = map(string)
}


# VM & Domain join variables ..

variable "vm_local_admin" {
  description = "Username for local admin"
  default     = "fiserv"
}

variable "hostname_prefix" {
  description = "Naming prefix for VMs"
}

variable "ou_path" {
  description = "The Organizational Unit to map the VM to."
}

variable "active_directory_domain" {
  description = "The domain to associate the VM to."
}

variable "active_directory_username" {
  description = "This is temporary and will be replaced by key-vault data object."
  default     = ""
}

variable "active_directory_password" {
  description = "This is temporary and will be replaced by key-vault data object."
  default     = ""
}

variable "user_assigned_id" {
  default = ""
}

variable "vm_specs" {
  type = map(object({
    instance_count              = number
    vm_size                     = string
    vm_image                    = string
    naming_std                  = string
    os_storage_type             = string
    os_disk_size                = number
    should_join_domain          = optional(bool, true)
    os_disk_enable_acceleration = bool
    data_disks = optional(list(object({
      name                = string
      size                = string
      storage_type        = string
      enable_acceleration = bool
    })), [])
    subnet_name                   = string
    associate_with_loadbalancer   = optional(bool, false)
    load_balancer_backend_pool_id = optional(string, null)
  }))
}

variable "apm_number" {
  type        = string
  default     = "APM0003743"
  description = "The APM Number of the Application"
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


variable "azure_entra_group_id" {
  type = string
}

variable "azure_entra_object_id" {
  type = string
}


############################################################################################################################




