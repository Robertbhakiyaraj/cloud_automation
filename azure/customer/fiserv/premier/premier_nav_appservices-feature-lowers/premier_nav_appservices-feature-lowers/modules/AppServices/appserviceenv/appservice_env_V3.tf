

resource "azurerm_resource_group" "appservice_resource_group" {
  name     = "RG-AppService-${var.app_name}-${var.env_name}-${var.resources_location}"
  location = var.resources_location
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "null_resource" "null_example" {
  provisioner "local-exec" {
    command = "sleep 60"  # Sleep for 60 seconds (adjust as needed)
  }
  depends_on = [azurerm_resource_group.appservice_resource_group]
}


resource "azurerm_app_service_environment_v3" "premier_appservice_v3" {
  name                         = "AppService-${var.app_name}-${var.env_name}"
  resource_group_name          = azurerm_resource_group.appservice_resource_group.name
  subnet_id                    = var.service_subnet_id 
  internal_load_balancing_mode = "Web, Publishing" ## HARD CODED .. NEVER Expose this to public. No CHOICE

  cluster_setting {
    name  = "DisableTls1.0"
    value = "1"
  }

  lifecycle {
    ignore_changes = [
      tags, # Ignore changes to tags because an azure policy updates these.
    ]
  }

  timeouts {
    create = "6h"
  }
}

#################Diagnostic settings#######################
resource "azurerm_monitor_diagnostic_setting" "diagnostic_logs" {
  name               = "ASEV3-EventHub-Logs-${var.app_name}-${var.env_name}"
  target_resource_id = azurerm_app_service_environment_v3.premier_appservice_v3.id
  eventhub_name      = "${var.app_name}-${var.env_name}-eventhub-logs"
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.auth_rule.id

  enabled_log {
    category = "AppServiceEnvironmentPlatformLogs"
  }

  metric {
    category = "AllMetrics"
    enabled = false //explicitly disable metrics to ensure tf plan does not output the removal of metrics on subsequent runs
  }
}