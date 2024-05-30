variable "resource_group_name" {
     type = string
     default = "example"
     description = "Name of the Resource Group"
}

variable "resource_group_location" {
     type = string
     default = "eastus2"
     description = "Location for resource group in which the resources will be created."
}

variable "azure_vault_name" {
     type = string
     default = "keyvault"
     description = "Azure Vault Name"
}

variable "azure_tenant_id" {
     type = string
     description = "Azure Tenant ID"
}

variable "enabled_for_disk_encryption" {
     type = string
     default = "value"
     description = "Enabled for Disk Encryption"
}
