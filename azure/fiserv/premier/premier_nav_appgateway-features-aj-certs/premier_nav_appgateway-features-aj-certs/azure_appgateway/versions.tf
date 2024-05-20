terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    ant = {
      source = "jlqpztfe01.onefiserv.net/fiserv-main/ant"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    key_vault {
      recover_soft_deleted_key_vaults       = true
      purge_soft_delete_on_destroy          = false
      recover_soft_deleted_keys             = true
      purge_soft_deleted_keys_on_destroy    = false
      recover_soft_deleted_secrets          = true
      purge_soft_deleted_secrets_on_destroy = false
    }
  }
}