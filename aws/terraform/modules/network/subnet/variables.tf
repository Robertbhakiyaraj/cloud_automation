variable "subnet_name" {
     type = string
     default = "example"
     description = "Name of the Subnet "
}

variable "resource_group_name" {
     type = string
     default = "example"
     description = "Name of the Resource Group Name "
}

variable "vnet_name" {
     type = string
     default = "example"
     description = "Name of the Virtual Network"
}

variable "address_prefixes" {
     type = list()
     default = ["10.0.2.0/24"]
     description = "Location for resource group in which the resources will be created."
}
