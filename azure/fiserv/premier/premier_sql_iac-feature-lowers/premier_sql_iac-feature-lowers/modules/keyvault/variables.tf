variable "subscription_id" {
     type = string
     description = "Subscription ID of the environment"
}
variable "key_vault_id" {
     type = string
     default = ""
     description = "The Key Vault ID"
}

variable "key_vault_location" {
     type = string
     default = ""
     description = "Key Vault Location"
}
    
variable "vnet_name" {
     type = string
     description = "The default existing Virtual Network Name"

}

variable "vnet_resourcegroup_name" {
     type = string
     description = "Virtual Network Resource Group name"

}

variable "location" {
     type = string
     description = "Default location"
}

variable "env_name" {
     type = string
     default = ""
     description = "Name of the environment ( lowers , cert , prod , dr )"
}

variable "app_name"{
     type = string
     default = ""
     description = "The app Short name"
}

variable "managed_principal_id" {
     default = ""
}

variable "rg_name"{
     type = string
     default = ""
     description = "Name of Resource group to create"
}
variable "subnet_map" {
     type = map(any)
}

variable "user_assigned_id" {
     default = ""
}