variable "cloudapp_subnets_cidrs_map" {
    type = map(string)
}

variable "app_name" {
    type    = string
    default = ""
}
variable "default_route_table_name"{
    type    = string
    default = ""
}
variable "env_name"{
    type    = string
    default = ""
}
variable "subscription_id"{
    type    = string
    default = ""
}
variable "vnet_name"{
    type    = string
    default = ""
}
variable "vnet_resourcegroup_name"{
    type    = string
    default = ""
}
variable "client_id_privateDNS" {
  default = ""
}
variable "client_secret_privateDNS" {
   default = ""
}
variable "subscription_id_kvPrivateDNS" {
   default = ""
}

variable "apm_number" {
     type = string
     description = "The APM Number of the Application"
}

variable "disk_encrypt_resource_grp_name" {
    type = string
    default = "des"
    description = "Name of the Disk encryption set resource group"
}