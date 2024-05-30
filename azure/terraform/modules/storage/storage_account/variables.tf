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

variable "storage_account_network_ip_rules" {
     type = list()
     default = ["100.0.0.1"]
     description = "Location for resource group in which the resources will be created."
}

variable "storage_account_network_subnet_ids" {
     type = list()
     default = []
     description = "Name of the Subnet ID"
}

variable "storage_account_network_default_action" {
     type = string
     default = "Deny"
     description = "Location for resource group in which the resources will be created."
}

variable "storage_account_name" {
     type = string
     default = "storageaccountname"
     description = "Location for resource group in which the resources will be created."
}

variable "storage_account_tier" {
     type = string
     default = "Standard"
     description = "Location for resource group in which the resources will be created."
}

variable "storage_account_replication_type" {
     type = string
     default = "LRS"
     description = "Location for resource group in which the resources will be created."
}

variable "tags" {
      type = list(object({
    name  = string
    value = string
  }))
  default = [
    { name = "env", value = "prod" },
    { name = "role", value = "app" },
  ]
     
     description = "Location for resource group in which the resources will be created."
}

