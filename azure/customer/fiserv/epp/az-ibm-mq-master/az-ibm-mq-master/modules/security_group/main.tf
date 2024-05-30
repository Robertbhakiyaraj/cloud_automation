module "network_security_group" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/network-security-group/azurerm"
  version = "v1.1.0"

  environment = var.env_name

  for_each = var.network_security_group_spec
  network_security_groups = {
  for n in range(1, 2) : "nsg${n}" => {
     name                                    = lookup(var.network_security_group_spec, each.key).security_group_name
     tags                                    = lookup(var.network_security_group_spec, each.key).tags
     resource_group_name                     = var.vm_rg
     location                                = lookup(var.network_security_group_spec, each.key).location
     attachment_type                         = lookup(var.network_security_group_spec, each.key).attachment_type
     nic_id                                  = var.nic_id                 
     subnet_name                             = var.nsg_subnet_name
     vnet_name                               = var.nsg_vnet_name
     networking_resource_group               = var.nsg_resource_group_name
     security_rules                          = lookup(var.network_security_group_spec, each.key).security_rules     
  }
}
  tags                                       =  { "nsg" = "${var.hostname_prefix}-${var.app_name}-${var.env_name}-${each.key}-nsg" }
}
