terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_storage_account" "example" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  network_rules {
    default_action             = var.storage_account_network_default_action
    ip_rules                   = var.storage_account_network_ip_rules
    virtual_network_subnet_ids = var.storage_account_network_subnet_ids
  }

  tags = {
     for_each = { for obj in var.tags : obj.name => obj }
    each.value.name = each.value.value
  }
}