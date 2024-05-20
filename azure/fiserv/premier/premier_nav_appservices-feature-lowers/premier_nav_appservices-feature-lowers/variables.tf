# Global variables
variable "subscription_id" {
  type        = string
  default     = ""
  description = "Premier NAV Lowers Subscription ID"

}

variable "app_name" {
  type        = string
  default     = "nav"
  description = "The app Short name"
}

variable "env_name" {
  type        = string
  default     = ""
  description = "Name of the environment ( lowers , cert , prod , dr )"
}

# Network stack variables

variable "vnet_name" {
  type        = string
  description = "Premier NAV Development Virtual Network Name"
}

variable "vnet_resourcegroup_name" {
  type        = string
  description = "Premier NAV Development Virtual Network Resource Group name"

}

variable "resources_location" {
  type = string
}


variable "default_route_table_name" {
  type        = string
  default     = "transit-rt"
  description = "Default Transit route table"
}


variable "cloudapp_subnets_cidrs_map" {
  type = map(string)
}

variable "apm_number" {
  type        = string
  default     = "APM0003473"
  description = "The APM Number of the Application"
}

variable "client_id_privateDNS" {
  default = ""
}
variable "client_secret_privateDNS" {
  default = ""
}
variable "subscription_id_privateDNS" {
  default = ""
}

variable "etghub_subscription_id" {
  type = string
}

variable "eventhub_namespace" {
  type = string
}

variable "eventhub_resource_group_name"{
  type = string
}

variable "eventhub_policy_name" {
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


variable "eventhub_logs_name" {
  type = string
}

variable "eventhub_metrics_name" {
  type = string
}


############################################################################################################################




