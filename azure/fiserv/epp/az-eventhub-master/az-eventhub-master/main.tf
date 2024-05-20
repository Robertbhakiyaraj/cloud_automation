#Module to create namespace, eventHub and Consumer Group
module "create_namespace_eventhub" {
  source                = "./modules/namespace-eventhub"
  namespaces            = var.namespaces
  namespace_eventhub_rg = var.namespace_eventhub_rg
}