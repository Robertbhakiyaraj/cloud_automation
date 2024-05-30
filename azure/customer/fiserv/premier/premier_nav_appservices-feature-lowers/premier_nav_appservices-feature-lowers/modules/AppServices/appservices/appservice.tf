
###############Key Vault##################################

resource "azurerm_resource_group" "appservice_resource_group" {
  name     = "rg-appservice-${var.app_name}-${var.env_name}"
  location = var.resources_location
}

resource "azurerm_storage_share" "storage_share" {
  name                 = "premiernav_config"
  storage_account_name = data.azurerm_storage_account.appservice_shared_store.name
  quota                = 50
}

#############App service##################################
resource "azurerm_windows_web_app" "app" {
  name                          = var.appservice_name
  resource_group_name           = data.azurerm_resource_group.appservice_resource_group.name
  location                      = each.value["location"]
  service_plan_id               = data.azurerm_service_plan.plan.id
  https_only                    = true
  public_network_access_enabled = false


  site_config {
    use_32_bit_worker      = false
    always_on              = true
    minimum_tls_version    = "1.2" # each.value["min_tls_version"]
    health_check_path      = "/"   # each.value["health_check_path"]
    default_documents      = "/"   # each.value["default_doc_set"] == "yes" ? [ each.value["default_documents"] ]: []
    vnet_route_all_enabled = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0"
    }
  }

  storage_account {
    name         = data.azurerm_storage_account.appservice_shared_store.name
    access_key   = data.azurerm_storage_account.appservice_shared_store.primary_access_key
    account_name = var.shared_storage_account
    type         = "AzureFiles"
    share_name   = azurerm_storage_share.storage_share.name
    ## Specify the Mount point here
  }

  logs {
    detailed_error_messages = true # each.value["detailed_error_messages_enabled"]
    failed_request_tracing  = true # each.value["failed_request_tracing_enabled"]
    application_logs {
      file_system_level = var.appservice_log_level
    }
    http_logs {
      file_system {
        retention_in_days = var.retain_http_logs_X_days # each.value["retention_in_days"]
        retention_in_mb   = var.http_log_retention_size #each.value["retention_in_mb"]
      }
    }
  }

  lifecycle {
    ignore_changes = [
      virtual_network_subnet_id, //this setting is ignored as we are using azurerm_app_service_virtual_network_swift_connection
      tags
    ]
  }
  #   identity {
  #     type = var.identity_type
  #   }
}


#############App Service Diagnostic Settings#########
resource "azurerm_monitor_diagnostic_setting" "diagnostic_logs" {
  name                           = "EventHub-Logs-${var.appservice_name}-${var.env_name}"
  target_resource_id             = azurerm_windows_web_app.app.id
  eventhub_name                  = var.eventhub_logs_name
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.auth_rule[0].id

  dynamic "enabled_log" {
    for_each = var.diagnostic_log_categories
    content {
      category = enabled_log.value["category"]
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false //explicitly disable metrics to ensure tf plan does not output the removal of metrics on subsequent runs
  }

}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_metrics" {
  name                           = "EventHub-Metrics-${var.appservice_name}-${var.env_name}"
  target_resource_id             = azurerm_windows_web_app.app.id
  eventhub_name                  = "evhb-splunk-${var.app_name}-${var.env_name}-metrics"
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.auth_rule[0].id

  metric {
    category = "AllMetrics"
  }

}

##############Private Endpoint################
resource "azurerm_private_endpoint" "pe" {
  name                = "${data.azurerm_windows_web_app.app.name}-endpoint" #var.team_number == "null" ? "${each.value["name"]}-endpoint" : "${each.value["name"]}-${var.team_number}-endpoint"
  resource_group_name = data.azurerm_resource_group.appservice_resource_group.name
  location            = each.value["location"]
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${data.azurerm_windows_web_app.app.name}-privateconnection"
    private_connection_resource_id = azurerm_windows_web_app.app[each.key].id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group,
      tags
    ]
  }
}

resource "azurerm_private_dns_a_record" "appservice_dns" {
  provider            = azurerm.private_dns
  for_each            = azurerm_private_endpoint.pe
  name                = split(".", each.value["custom_dns_configs"][0]["fqdn"])[0]
  zone_name           = var.appservice_private_DNS_zone
  resource_group_name = var.private_dns_zone_resource_group_name
  ttl                 = 300
  records             = each.value["custom_dns_configs"][0]["ip_addresses"]
}

##############Set Miminum TLS Cipher Suite #################
resource "null_resource" "set_min_tls_cipher" {
  depends_on = [azurerm_windows_web_app.app]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = ".'${path.module}\\minimum_tls_cipher_suite.ps1' -ResourceGroupName ${data.azurerm_resource_group.appservice_resource_group.name} -AppServiceName ${data.azurerm_windows_web_app.app.name} "
    interpreter = ["PowerShell", "-Command"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
