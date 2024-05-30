# Global variables
variable "subscription_id" {
  type        = string
  default     = ""
  description = "Premier NAV Lowers Subscription ID"

}

variable "apm_number" {
  type = string
  default = "APM0003473"
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


variable "cloudapp_subnets_cidrs_map" {
  type = map(string)
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




