variable "app_name" {
  type        = string
  description = "The app Short name"
}

variable "env_name" {
  type        = string
  description = "Name of the environment ( lowers , cert , prod , dr )"
}


variable "vnet_resourcegroup_name" {
  type = string
}

variable "service_subnet_id" {
  type = string
}

variable "resources_location" {
  type = string
}

variable "eventhub_policy_name" {
  type = string
}
variable "eventhub_resource_group_name" {
    type = string

}

variable "eventhub_namespace" {
  type = string
}
