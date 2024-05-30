variable "app_name" {
  type        = string
  description = "The app Short name"
}

variable "env_name" {
  type        = string
  description = "Name of the environment ( lowers , cert , prod , dr )"
}

variable "resources_location" {
  type = string
}

variable "AppServicePlan" {
  type = map(object({
    name = string
    sku = string
    worker_count = optional(number , 2)
    os_type = optional(string , "windows") 
  }))
}

variable "vnet_resourcegroup_name" {
  type = string
}

variable "eventhub_name" {
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

variable "eventhub_metrics_name" {
  type = string
}