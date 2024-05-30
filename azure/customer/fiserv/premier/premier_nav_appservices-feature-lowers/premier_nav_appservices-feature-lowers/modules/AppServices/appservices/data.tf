data "azurerm_client_config" "current" {}

################Diagnostc Categories#####################
data "azurerm_eventhub_namespace_authorization_rule" "auth_rule" {
  provider            = azurerm.ETGHub
  name                = var.eventhub_policy_name
  resource_group_name = var.eventhub_resource_group_name
  namespace_name      = var.eventhub_namespace
}

data "azurerm_storage_account" "appservice_shared_store" {
  name                = var.shared_storage_account
  resource_group_name = var.storage_resource_group
}