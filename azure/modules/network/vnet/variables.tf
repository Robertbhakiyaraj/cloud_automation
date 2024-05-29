variable "location" {
     type = string
     default = "eastus2"
     description = "Location for resource group in which the resources will be created."
}

variable "vnet_name" {
     type = string
     default = "example"
     description = "Name of the Virtual Network "
}
