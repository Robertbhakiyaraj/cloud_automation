variable "network_interface_name" {
     type = string
     default = "example"
     description = "Name of the Network Interface"
}

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

variable "ip_configuration_name" {
     type = string
     default = "internal"
     description = "Name of the IP Configuration "
}

variable "private_ip_address_allocation" {
     type = string
     default = "Dynamic"
     description = "Type of the Private IP Address Allocation"
}

variable "subnet_id" {
     type = string
     default = "example"
     description = "Name of the Subnet ID"
}

variable "linux_virtual_machine_name" {
     type = string
     default = "example"
     description = "Name of Linux Virtual Machine"
}

variable "linux_virtual_machine_size" {
     type = string
     default = "Standard_F2"
     description = "Size of Linux Virtual Machine"
}

variable "linux_virtual_machine_admin_username" {
     type = string
     default = "adminuser"
     description = "Linux Virtual Machine Admin Username"
}

variable "linux_virtual_machine_public_sshkey" {
     type = string
     default = ""
     description = "Linux Virtual Machine Admin Public SSH Key"
}

variable "os_disk_caching" {
     type = string
     default = "ReadWrite"
     description = "OS Disk Caching"
}

variable "os_disk_storage_account_type" {
     type = string
     default = "Standard_LRS"
     description = "OS Disk Caching Storage Account Type"
}

variable "source_image_reference_publisher" {
     type = string
     default = "Canonical"
     description = "Source Image Reference Publisher"
}

variable "source_image_reference_offer" {
     type = string
     default = "0001-com-ubuntu-server-jammy"
     description = "Source Image Reference Offer"
}

variable "source_image_reference_sku" {
     type = string
     default = "22_04-lts"
     description = "Source Image Reference sku"
}

variable "source_image_reference_version" {
     type = string
     default = "latest"
     description = "Source Image Reference Version"
}


