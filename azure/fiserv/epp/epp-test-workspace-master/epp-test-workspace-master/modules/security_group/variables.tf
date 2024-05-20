 #Common/Application Declarations
variable "app_name" {
    type = string
}

variable "env_name"  {
    type = string
}

variable "apm_number"  {
    type = string
}

variable "hostname_prefix"  {
    type = string
}

#Security Group Declarations
 variable "environment" {
   type  = string
 }


variable "network_security_group_spec" {
  type = map(any)
}

variable "vm_rg" {
  type = string
}

variable "nic_id" {
   type = list(string)
 }

variable "nsg_subnet_name" {
  type = string
  
}

variable "nsg_vnet_name" {
  type=string 
}

variable "nsg_resource_group_name" {
  type = string  
}


variable "tags" {
   type = map(string)
 }

