// Required
variable "rg_name" {
  type        = string
  description = "Name of the resource group to place App Gateway in."
}
variable "rg_location" {
  type        = string
  description = "Location of the resource group to place App Gateway in."
}
variable "name" {
  type        = string
  description = "Name of App Gateway"
}

variable "vnet_name" {
  type        = string
  description = "Name of virtual network in which to place the gateway"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet in which to place the gateway"
}

variable "private_ip_address_allocation" {
  type        = string
  description = "Static or Dynamic"
  default     = "Dynamic"

  validation {
    condition     = contains(["Static", "Dynamic"], var.private_ip_address_allocation)
    error_message = "Valid values for var: private_ip_address_allocation are (Static, Dynamic)."
  }
}

variable "private_ip_address" {
  type        = string
  description = "The Statically-Assigned IP address of the App Gateway Front-End"
  default     = null
}
variable "appgateway_premier_resource_group_name"{
  type = string

}
variable "appgateway_premier_vnet" {
  type = string
  
}
  
variable "appgateway_premier_subnet_ip_range" {
  type    = list(string)
  default = [""]
}

variable "app_name" {
  type        = string
  default     = ""
  description = "The app Short name"
}

variable "env_name" {
  type        = string
  default     = ""
  description = "Name of the environment ( lowers , cert , prod , dr )"
}

variable "subscription_id" {
  type        = string
  default     = ""
  description = "Premier Cert Subscription ID"

}
