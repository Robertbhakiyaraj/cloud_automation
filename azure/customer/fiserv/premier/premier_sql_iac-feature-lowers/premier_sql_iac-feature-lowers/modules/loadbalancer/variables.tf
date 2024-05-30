variable "resource_group_name"{
    type    = string
}

variable "load_balancer_config" {
    type = map(object({
        lb_name = string
        lb_port = number
        lb_probe_path = string
        subnet_name = string
        probe_interval = number
        probe_threshold = number
        location    = string
    }))
}

variable "subnet_map" {
  type        = map(any)
}

variable "lb_ipaddress" {
    type = string
}
