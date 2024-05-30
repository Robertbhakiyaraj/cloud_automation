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

variable "vm_rg" {
    type = string
}

variable "vm_location" {
    type = string
}

#General Declarations
variable "common_tags" {
    type = map(any)
}

variable "keyvault_id"  {
    type = string
}

variable "disk_encryption_set_resource_group_name" {
    type = string
}

variable "disk_encryption_set_name" {
    type = string
}

variable "customer_managed_key_name" {
    type = string
}

#variable "disk_encryption_set_id" {
#    type = string
#}

#variable "disk_encryption_set_managed_identity_ids" {
#    type = list(string)
#}

#variable "customer_managed_key_id" {
#    type = string
#}



#vm_nics Declarations

variable "subnet_id" {
    type = string 
}

variable "vnet_rg" {
    type = string
}


#virtual_machines Declarations

variable "vm_specs" {
    type = map(any)
}

variable "managed_identity_ids" {
    type = list(string)
}

#variable "custom_data" {
#    type = string 
#}




