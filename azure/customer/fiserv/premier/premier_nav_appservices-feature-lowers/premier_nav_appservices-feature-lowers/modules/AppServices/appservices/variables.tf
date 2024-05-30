variable "appservice_private_DNS_zone" {
  type    = string
  default = "privatelink.azurewebsites.net"
}

variable "private_dns_zone_resource_group_name" {
  type        = string
  description = "Resource Group name of Private DNS Zone Name"
  default     = "prod-bluecat-dns-ofs-hybrid-shared-dns-rg"
}

variable "subscription_id" {
  type        = string
  description = "premier nav Development Subscription ID"

}

variable "app_name" {
  type        = string
  description = "The app Short name"
}

variable "env_name" {
  type        = string
  description = "Name of the environment ( lowers , cert , prod , dr )"
}

variable "resources_location" {
  description = "The location in which the resources will be created."
  type        = string
}


# Network stack variables

variable "vnet_name" {
  type        = string
  description = "premier nav Development Virtual Network Name"

}

variable "vnet_resourcegroup_name" {
  type        = string
  description = "premier nav Development Virtual Network Resource Group name"
}

variable "default_route_table_name" {
  type        = string
  default     = "transit-rt"
  description = "Default Transit route table"
}


variable "appservice_name" {
  type = string
}

variable "appservice_log_level" {
  type = string
}

variable "retain_http_logs_X_days" {
  type    = number
  default = 7
}

variable "http_log_retention_size" {
  type = number
}

variable "eventhub_logs_name" {
  type = string
}

variable "eventhub_metrics_name" {
  type = string
}


variable "shared_storage_account" {
  type = string
}

variable "storage_resource_group" {
  type = string
}

variable "diagnostic_log_categories" {
  type    = list(string)
  default = ["AppServiceAntivirusScanAuditLogs", "AppServiceConsoleLogs", "AppServiceFileAuditLogs", "AppServicePlatformLogs", "AppServiceHTTPLogs", "AppServiceIPSecAuditLogs", "AppServiceAuditLogs", "AppServiceAppLogs"]
}
