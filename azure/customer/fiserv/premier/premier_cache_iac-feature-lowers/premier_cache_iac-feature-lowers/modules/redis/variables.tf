variable "app_name" {
    type = string
}

variable "env_name" {
    type = string
}

variable "cache_location" {
    type = string
}

/* *******  DO NOT CHANGE THESE ************* */

variable "dns_resource_group_name" {
  default = "prod-bluecat-dns-ofs-hybrid-shared-dns-rg"
}

variable "dns_zone_name" {
  default = "privatelink.redis.cache.windows.net"
}
/* *******  DO NOT CHANGE THESE ************* */

variable "capacity" {
  default = 0
}
variable "family" {
  default = "C"
}

variable "sku_name" {
  default = "Standard"
}

variable "enable_non_ssl_port" {
  default = false
}

variable "minimum_tls_version" {
  default = "1.2"
}

variable "subnet_map" {
  type        = map(any)
}
