variable "subscription_id" {
     type = string
     description = "Subscription ID of the environment"
}

variable "vnet_name" {
     type = string
     description = "Virtual Network Name"
}

variable "vnet_resourcegroup_name" {
     type = string
     description = "Virtual Network Resource Group name"
}

variable "rg_name"{
     type = string
     default = ""
     description = "Name of Resource group to create"
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
