module "resourcegroups" {
  source   = "jlqpztfe01.onefiserv.net/fiserv-main/resource-group/azurerm"
  version  = "1.0.12"
  name     = "rg-${var.app_name}-${var.env_name}-${var.rg_name}-${data.azurerm_resource_group.existing_vnet_rg.location}"
  location =  data.azurerm_resource_group.existing_vnet_rg.location
}

resource "null_resource" "null_example" {
  provisioner "local-exec" {
    command = "sleep 60"  # Sleep for 60 seconds (adjust as needed)
  }
  depends_on = [module.resourcegroups]
}
