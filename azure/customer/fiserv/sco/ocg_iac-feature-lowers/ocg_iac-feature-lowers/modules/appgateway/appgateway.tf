# Create the application gateway
resource "azurerm_application_gateway" "app-gateway" {
  name                = "appgw-${var.app_name}-${var.env_name}"
  location            = module.rg_eus2_net.location
  resource_group_name = module.rg_eus2_net.name

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
  }

  autoscale_configuration {
    min_capacity     = var.appgw_sku_capacity
  }

  # ALL
  frontend_ip_configuration {
    name                          = "config-appgw-${var.app_name}-${var.env_name}"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.appgw_dr_private_ip_address
    subnet_id                     = module.subnet_dir_app_gw_eus2.subnet_id[0]
  }

  gateway_ip_configuration {
    name      = "config-appgw-${var.app_name}-${var.env_name}"
    subnet_id = module.subnet_dir_app_gw_eus2.subnet_id[0]
  }

  # Define the frontend port
  frontend_port {
    name = var.appgw_frontend_port_name
    port = var.appgw_frontend_port
  }

  # Certificates
  ssl_certificate {
    name     = var.appgw_ssl_cert_name
    data     = filebase64(var.appgw_ssl_cert_file)
    password = var.cert_password
  }

  # Define the frontend listeners
  dynamic "http_listener" {
    for_each = var.appgw_01_sites
    content {
      name                           = "listener-${http_listener.value.site_name}-01"
      frontend_ip_configuration_name = "config-appgw-${var.app_name}-${var.env_name}"
      frontend_port_name             = var.appgw_frontend_port_name
      protocol                       = "Https"
      host_name                      = http_listener.value.host_name
      ssl_certificate_name           = var.appgw_ssl_cert_name
    }
  }

  # Define the backend address pools
  dynamic "backend_address_pool" {
    for_each = var.appgw_01_sites
    content {
      name = "backend-pool-dir-${var.env_name}-${backend_address_pool.value.site_name}"
    }
  }


  # Define the backend HTTP settings
  dynamic "backend_http_settings" {
    for_each = var.appgw_01_sites
    content {
      name                                = "${backend_http_settings.value.site_name}-01-https"
      cookie_based_affinity               = "Enabled"
      port                                = var.appgw_frontend_port
      protocol                            = "Https"
      request_timeout                     = 30
      probe_name                          = "probe-${backend_http_settings.value.site_name}-01"
      pick_host_name_from_backend_address = false
      connection_draining {
        enabled           = var.appgw_connection_draining
        drain_timeout_sec = var.appgw_drain_timeout_sec
      }
    }
  }

  dynamic "url_path_map" {
    for_each = var.appgw_01_sites
    content {
      name                               = "${url_path_map.value.site_name}-path-map"
      default_backend_address_pool_name  = "backend-pool-dir-${var.env_name}-${url_path_map.value.site_name}"
      default_backend_http_settings_name = "${url_path_map.value.site_name}-01-https"

      dynamic "path_rule" {
        for_each = url_path_map.value.paths
        content {
          name                       = "${url_path_map.value.site_name}-default-path"
          backend_address_pool_name  = "backend-pool-dir-${var.env_name}-${url_path_map.value.site_name}"
          backend_http_settings_name = "${url_path_map.value.site_name}-01-https"
          paths                      = [path_rule.value]
        }
      }
    }
  }

  # Define the request routing rules
  dynamic "request_routing_rule" {
    for_each = var.appgw_01_sites
    content {
      name                       = "rule-${request_routing_rule.value.site_name}"
      rule_type                  = "PathBasedRouting"
      http_listener_name         = "listener-${request_routing_rule.value.site_name}-01"
      backend_address_pool_name  = "backend-pool-dir-${var.env_name}-${request_routing_rule.value.site_name}"
      backend_http_settings_name = "${request_routing_rule.value.site_name}-01-https"
      url_path_map_name          = "${request_routing_rule.value.site_name}-path-map"
      priority                   = request_routing_rule.key + 1
    }
  }

  # Define the health probes
  dynamic "probe" {
    for_each = var.appgw_01_sites
    content {
      name                                      = "probe-${probe.value.site_name}-01"
      protocol                                  = "Https"
      path                                      = "/l7check/l7check"
      interval                                  = 30
      timeout                                   = 30
      unhealthy_threshold                       = 3
      pick_host_name_from_backend_http_settings = false
      host                                      = probe.value.host_name
    }
  }
    depends_on = [
    module.rg_eus2_net
  ]
}