variable "vnet_resourcegroup_name" {
     type = string
     default = ""
     description = "Virtual Network Resource Group name"
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

variable "rg_name"{
     type = string
     default = ""
     description = "Name of Resource group to create"
}

variable "resource_location" {
     type = string
     description = "Azure Region/Location"
}