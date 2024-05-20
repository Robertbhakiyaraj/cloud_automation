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
  frontend_private_ip_address            = var.lb_ipaddress
  lb_sku                                 = "Standard"
  enable_floating_ip                     = true
  backend_pool_name                      = "LB-backend-${var.load_balancer_config["lb_config"].lb_name}"
  frontend_private_ip_availability_zones = ["1", "2", "3"]

  lb_port = {
    tcp = [var.load_balancer_config["lb_config"].lb_port, "Tcp", var.load_balancer_config["lb_config"].lb_port]
  }
  lb_probe = { 
    tcp = ["Http", var.load_balancer_config["lb_config"].lb_port, "${var.load_balancer_config["lb_config"].lb_probe_path}"]
  }

  lb_probe_interval = var.load_balancer_config["lb_config"].probe_interval
  lb_probe_unhealthy_threshold = var.load_balancer_config["lb_config"].probe_threshold

  tags = {
    source = "terraform"
  }
}