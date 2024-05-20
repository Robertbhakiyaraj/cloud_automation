
# Global variables
variable "subscription_id" {
     type = string
     default = "8ca1bf4b-6b75-4427-9677-356fa252d6c2"
     description = "OCG Development Subscription ID"

}

variable "app_name"{
    type = string
    default = "ocg"
     description = "The app Short name"
}

variable "env_name" {
     type = string
     default = ""
     description = "Name of the environment ( lowers , cert , prod , dr )"
}

variable "location" {
  description = "The location in which the resources will be created."
  default = "eastus2"
  type        = string
}

# Network stack variables

variable "vnet_name" {
     type = string
     default = "non-prod-vnet-ocg-devel-eastus2-d6c2"
     description = "OCG Development Virtual Network Name"

}

variable "vnet_resourcegroup_name" {
     type = string
     default = "non-prod-ocg-devel-eastus2-vnet-rg"
     description = "OCG Development Virtual Network Resource Group name"

}

variable "default_route_table_name" {
     type = string
     default = "transit-rt"
     description = "Default Transit route table"
}


variable "cloudapp_subnets_cidrs_map" {
    type = map(string)
}


# VM & Domain join variables ..

variable "vm_local_admin" {
  description = "Username for local admin"
  default     = "fiserv"
}

variable "vm_naming_prefix" {
  description = "Naming prefix for VMs"
  default     = "l7wd2ocg"
}

variable "ou_path" {
  description = "The Organizational Unit to map the VM to."
  default     = "OU=ORBO,OU=Deposit Solutions,OU=Servers,OU=Testing,DC=ec,DC=checkfree,DC=com"
}

variable "active_directory_domain" {
  description = "The domain to associate the VM to."
  default     = "ec.checkfree.com"
}

variable "active_directory_username" {
  description = "This is temporary and will be replaced by key-vault data object."
  default     = ""
}

variable "active_directory_password" {
  description = "This is temporary and will be replaced by key-vault data object."
  default     = ""
}

variable "vm_specs" {
    type = map(any)
}

variable "appvm_eastus2_rg_name" {
  description = "App subnet vm resource grup name."
  default     = "rg-ocg-dev-eastus2-app"
}


# Kayvault variables
variable "kv_eastus2_rg_name" {
  description = "KV resource group name"
  default     = ""
}

variable "apm_number" {
     type = string
     default = "APM0006559"
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


############################################################################################################################




