terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "premier_nav_appservices_support"
    }
  }
}

## Create a subnet for the GPU VMs 
module "cloud_subnets" {
  source                   = "./modules/network"
  for_each                 = var.cloudapp_subnets_cidrs_map
  subscription_id          = var.subscription_id
  vnet_name                = var.vnet_name
  vnet_resourcegroup_name  = var.vnet_resourcegroup_name
  default_route_table_name = var.default_route_table_name
  cloud_subnet_name        = "subnet-${var.app_name}-${var.env_name}-${each.key}"
  cloud_subnet_ip          = each.value
}

module "premier_appservice_env" {
  source = "./modules/AppServices/appserviceenv"
  app_name = var.app_name
  env_name = var.env_name
  eventhub_namespace = var.eventhub_namespace
  eventhub_policy_name = var.eventhub_policy_name
  service_subnet_id = module.cloud_subnets["service"].subnet_details.subnet_id[0]
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  eventhub_resource_group_name = var.eventhub_resource_group_name
  resources_location = var.resources_location
}

module "premier_appservice_plan" {
  source = "./modules/AppServices/appserviceplan"
  AppServicePlan = var.AppServicePlan
  env_name = var.env_name
  app_name =  var.app_name
  eventhub_namespace = var.eventhub_namespace
  eventhub_metrics_name = var.eventhub_metrics_name
  vnet_resourcegroup_name = var.vnet_resourcegroup_name
  eventhub_resource_group_name = var.eventhub_resource_group_name
  eventhub_policy_name = var.eventhub_policy_name
  eventhub_name = "test-eventhub-name"
  resources_location = var.resources_location
}

module premier_webappservice {
  source = "./modules/AppServices/appservices"
  app_name = var.app_name
  env_name = var.env_name
  vnet_name = var.vnet_name
  subscription_id = var.subscription_id
  eventhub_logs_name = var.eventhub_logs_name
  eventhub_metrics_name = var.eventhub_metrics_name
resources_location = var.resources_location
vnet_resourcegroup_name = var.vnet_resourcegroup_name
http_log_retention_size = "" #var.http_log_retention_size
shared_storage_account = ""
storage_resource_group = ""
appservice_log_level = ""
appservice_name = ""

}
