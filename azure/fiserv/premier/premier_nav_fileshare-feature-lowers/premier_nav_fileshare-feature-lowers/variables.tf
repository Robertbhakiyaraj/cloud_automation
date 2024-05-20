# Global variables
variable "subscription_id" {
  type        = string
  default     = ""
  description = "Premier NAV Lowers Subscription ID"

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
  type        = string
}

# Network stack variables

variable "vnet_name" {
  type        = string
  description = "Premier NAV Development Virtual Network Name"
}

variable "vnet_resourcegroup_name" {
  type        = string
  description = "Premier NAV Development Virtual Network Resource Group name"

}

variable "default_route_table_name" {
  type        = string
  default     = "transit-rt"
  description = "Default Transit route table"
}


variable "filestore_subnet_name" {
    type = string
}


variable "apm_number" {
  type        = string
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

variable "filestorage_name" {
  type = string
}