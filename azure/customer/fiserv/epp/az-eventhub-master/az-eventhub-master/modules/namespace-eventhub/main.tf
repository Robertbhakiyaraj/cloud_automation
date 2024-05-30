# Create namespaces dynamically
resource "azurerm_eventhub_namespace" "namespace" {
  count                              = length(var.namespaces)
  name                               = var.namespaces[count.index].name
  resource_group_name                = var.namespace_eventhub_rg
  location                           = var.namespaces[count.index].location
  sku                                = var.namespaces[count.index].sku
  capacity                           = var.namespaces[count.index].capacity
  dedicated_cluster_id               =  var.namespaces[count.index].dedicated_cluster_id
  auto_inflate_enabled               = var.namespaces[count.index].auto_inflate_enabled
  maximum_throughput_units           = var.namespaces[count.index].maximum_throughput_units 
  zone_redundant                     = var.namespaces[count.index].zone_redundant
  local_authentication_enabled       = var.namespaces[count.index].local_authentication_enabled
  public_network_access_enabled      = var.namespaces[count.index].public_network_access_enabled
  minimum_tls_version                = var.namespaces[count.index].minimum_tls_version
  tags                               = var.namespaces[count.index].tags
  network_rulesets                   = var.namespaces[count.index].network_rulesets


}

#Flatten event hubs for easier iteration
locals {
  flattened_eventhubs                = flatten([for ns in var.namespaces : [for eh in ns.eventhubs :  { namespace_name = ns.name, eventhub = eh}] ])
}

#Flatten consumer_groups for easier iteration
locals {
  flattened_consumergroups           = flatten([for ns in var.namespaces : [for eh in ns.eventhubs : [for cg in eh.consumer_groups: { namespace_name = ns.name, eventhub = eh , consumer_group = cg}] ]])
}

# Create event hubs dynamically
resource "azurerm_eventhub" "eventhub" {
  count                              = length(local.flattened_eventhubs)
  name                               = local.flattened_eventhubs[count.index].eventhub.name
  namespace_name                     = local.flattened_eventhubs[count.index].namespace_name
  partition_count                    = local.flattened_eventhubs[count.index].eventhub.partition_count
  message_retention                  = local.flattened_eventhubs[count.index].eventhub.message_retention
  resource_group_name                = var.namespace_eventhub_rg
  depends_on                         = [ resource.azurerm_eventhub_namespace.namespace ]
}

# Create consumer groups
resource "azurerm_eventhub_consumer_group" "consumer_group" {
  count                              = length(local.flattened_consumergroups)
  namespace_name                     = local.flattened_consumergroups[count.index].namespace_name
  eventhub_name                      = local.flattened_consumergroups[count.index].eventhub.name
  name                               = local.flattened_consumergroups[count.index].consumer_group
  resource_group_name                = var.namespace_eventhub_rg
  depends_on                         = [resource.azurerm_eventhub.eventhub]
}