############ASE V3################################
# data "azurerm_app_service_environment_v3" "asev3" {
#   name                = each.value["name"]
#   resource_group_name = each.value["resource_group_name"]
# }

################Auth Rule#####################
# data "azurerm_eventhub_namespace_authorization_rule" "auth_rule" {
#   provider            = azurerm.ETGHub
#   name                = var.eventhub_policy_name
#   resource_group_name = var.eventhub_resource_group_name
#   namespace_name      = var.eventhub_namespace
# }

############Service Plan################################
resource "azurerm_service_plan" "serviceplan" {
  name                       = "AppServicePlan-${var.app_name}-${var.env_name}-${var.resources_location}"
  resource_group_name        = var.vnet_resourcegroup_name
  location                   = var.resources_location

  for_each                   = var.AppServicePlan
  os_type                    = each.value["os_type"]
  sku_name                   = each.value["sku"]
  # app_service_environment_id = data.azurerm_app_service_environment_v3.asev3.id ## Commented in the lowers
  worker_count               = each.value["worker_count"]

  lifecycle {
    ignore_changes = [
      tags, # Ignore changes to tags because an azure policy updates these.
    ]
  }
}

#################Diagnostic settings#######################
resource "azurerm_monitor_diagnostic_setting" "diagnostic_metrics" {
  name               = "EventHub-Metrics-${var.app_name}-${var.env_name}-${var.resources_location}"
  target_resource_id = azurerm_service_plan.serviceplan[0].id
  eventhub_name      = var.eventhub_metrics_name
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.auth_rule.id

  metric {
    category = "AllMetrics"
  }
}
