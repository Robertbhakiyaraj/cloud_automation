output "lb_backend_address_pool_id" {
  description = "the id for the azurerm_lb_backend_address_pool resource"
  value       = module.internal_load_balancer.lb_backend_address_pool_id
}
