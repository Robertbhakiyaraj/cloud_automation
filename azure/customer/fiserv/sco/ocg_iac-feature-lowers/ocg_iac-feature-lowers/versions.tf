terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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

provider "azurerm" {
  alias                      = "kv_privateDNS"
  client_id                  = var.client_id_privateDNS
  client_secret              = var.client_secret_privateDNS
  subscription_id            = var.subscription_id_kvPrivateDNS
  skip_provider_registration = true
  features {}
}

