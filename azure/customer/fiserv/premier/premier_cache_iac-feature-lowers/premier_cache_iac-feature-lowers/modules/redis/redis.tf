

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current_subscription" {}
locals {
  mandatory_tags = {
    BluePrintModule = "terraform-azurerm-resource-group"
    DateCreated     = timestamp()
    Environment     = var.env_name
  }
}

resource "azurerm_resource_group" "redis_cache_rg" {
  name     = "rg-${var.app_name}-${var.env_name}-redis-${var.cache_location}"
  location = var.cache_location
  tags     = merge(data.azurerm_subscription.current_subscription.tags, local.mandatory_tags)
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

module "redis" {
  providers = {
    // azurerm             = azurerm
    azurerm.private_dns = azurerm.private_dns
  }

  source                  = "jlqpztfe01.onefiserv.net/fiserv-main/redis-cache-set/azurerm"
  resource_group_name     = "rg-${var.app_name}-${var.env_name}-redis-${var.cache_location}"
  resource_group_location = var.cache_location
  name                    = "cache-${var.app_name}-${var.env_name}-${var.cache_location}"
  capacity                = var.capacity
  family                  = var.family
  sku_name                = var.sku_name
  subnet_id               = var.subnet_map["cache"].subnet_details.subnet_id
  dns_resource_group_name = var.dns_resource_group_name
  dns_zone_name           = var.dns_zone_name
  enable_non_ssl_port     = var.enable_non_ssl_port
  minimum_tls_version     = var.minimum_tls_version

  /* patch_schedule {
    day_of_week           = var.day_of_week
    start_hour_utc        = var.start_hour_utc
    duration_hours        = var.duration_hours
  } */

  depends_on = [azurerm_resource_group.redis_cache_rg]
}
