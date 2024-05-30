# Create Azure Load Balancer
module "internal_load_balancer" {
  source                                 = "jlqpztfe01.onefiserv.net/fiserv-main/loadbalancer/azurerm"
  version                                = "1.1.4"
  resource_group_name                    = var.resource_group_name
  location                               = var.load_balancer_config["lb_config"].location
  name                                   = "LB-${var.load_balancer_config["lb_config"].lb_name}"
  type                                   = "private"
  frontend_name                          = "LB-frontend-${var.load_balancer_config["lb_config"].lb_name}"
  frontend_subnet_id                     = var.subnet_map[var.load_balancer_config["lb_config"].subnet_name].subnet_details.subnet_id
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = cidrhost(var.lb_subnet_cidr , 4)
  lb_sku                                 = "Standard"
  enable_floating_ip                     = true
  backend_pool_name                      = "LB-backend-${var.load_balancer_config["lb_config"].lb_name}"
  frontend_private_ip_availability_zones = ["1", "2", "3"]

  lb_port = {
    http = [80, "Tcp", 80]
    https = [443, "Tcp", 443]
  }
  lb_probe = { 
    http = ["Http", 80, "${var.load_balancer_config["lb_config"].lb_probe_path}"]
    https = ["Https", 443 , "${var.load_balancer_config["lb_config"].lb_probe_path}"] 
  }

  lb_probe_interval = var.load_balancer_config["lb_config"].probe_interval
  lb_probe_unhealthy_threshold = var.load_balancer_config["lb_config"].probe_threshold

  tags = {
    source = "terraform"
  }
}