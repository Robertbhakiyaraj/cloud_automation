variable "vnet_name" {
     type = string
     default = "example"
     description = "Name of the Virtual Network "
}

variable "resource_group_name" {
     type = string
     default = "example"
     description = "Name of the Resource Group Name "
}

variable "resource_group_location" {
     type = string
     default = "eastus2"
     description = "Location for resource group in which the resources will be created."
}

variable "address_space" {
     type = list()
     default = ["10.0.0.0/16"]
     description = "Location for resource group in which the resources will be created."
}
