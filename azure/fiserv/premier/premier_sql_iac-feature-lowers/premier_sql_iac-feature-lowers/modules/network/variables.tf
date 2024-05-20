variable "subscription_id" {
     type = string
     description = "Subscription ID of the environment"

}
variable "cloud_subnet_name" {
     type = string
     default = ""
     description = "Name of subnet being created in the cloud"
}

variable "cloud_subnet_ip" {
     type = string
     default = ""
     description = "IP range of the subnet being created in the Cloud"
}
    
variable "vnet_name" {
     type = string
     description = "Virtual Network Name"

}

variable "vnet_resourcegroup_name" {
     type = string
     description = "Virtual Network Resource Group name"

}
variable "default_route_table_name" {
     type = string
     description = "Default Transit route table"
}
