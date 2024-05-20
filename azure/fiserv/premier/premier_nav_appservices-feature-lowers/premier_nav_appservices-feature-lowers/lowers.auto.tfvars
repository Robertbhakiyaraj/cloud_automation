subscription_id          = ""
vnet_name                = ""
vnet_resourcegroup_name  = ""
default_route_table_name = "transit-rt"

app_name   = ""
env_name   = ""
apm_number = ""
resources_location = ""

cloudapp_subnets_cidrs_map = {
  "service"    = ""
}

etghub_subscription_id       = ""
eventhub_namespace           = ""
eventhub_resource_group_name = ""
# eventhub_policy_name         = ""
eventhub_logs_name              = ""
eventhub_metrics_name           = ""


AppServicePlan = {
  NavUI = {
    name = "NavUI"
    os_type = "Windows"
    sku = "B3"
    worker_count = 2
  }
}

