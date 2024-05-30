terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "premier_nav_appgateway_cert"
    }
  }
}
module "create_subnet" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/subnets/azurerm"
  version = " 1.0.15 " # Example. Use The latest version
 

  providers = {
    azurerm = azurerm.appgateway_premier
  }

  subnets = {
    subnet1 = {
      name                 = "${var.app_name}-${var.env_name}-appsubenets"
      resource_group_name  = data.azurerm_resource_group.appgateway_premier_network_rg.name
      virtual_network_name = data.azurerm_virtual_network.appgateway_premier.name
      address_prefixes     = var.appgateway_premier_subnet_ip_range #"<your subnet IP range>""
      service_endpoints    = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
      pe_enable            = false
      delegation           = []
    }
  }
}

module "create_appgateway" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/appgateway/azurerm"
  version = "1.1.1" # Example. Use The latest version
 

  providers = {
    azurerm = azurerm.appgateway_premier
  }


  name                          = "${var.app_name}-${var.env_name}-appgateway"
  rg_location                   = data.azurerm_resource_group.appgateway_premier.location
  rg_name                       = data.azurerm_resource_group.appgateway_premier.name
  vnet_name                     = data.azurerm_virtual_network.appgateway_premier.name
  subnet_id                     = module.create_subnet.subnet_id[0]
  private_ip_address_allocation = "Dynamic"
  

  

  backend_address_pools = {
    name         = local.api-beap
    ip_addresses = null
    fqdns        = ["test.com"]
  }

  backend_http_settings = {
    name                  = local.api-htst
    path                  = "/api/"
    is_https              = true
    request_timeout       = 30
    probe_name            = null
    cookie_based_affinity = "Enabled"
  }


  probes = {
    interval                                  = 30
    name                                      = local.probe-name
    path                                      = local.probe-path
    protocol                                  = probe.value.is_https ? "Https" : "Http"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }


  http_listeners = {
    name                 = local.http-listener
    ssl_certificate_name = null
    host_name            = null
    require_sni          = false
  }



  path_based_request_routing_rules = {
    name               = "http-rqrt"
    rule_type          = "Baisc"
    http_listener_name = local.http-listener
    url_path_map_name  = "http-url-path"
  }

}