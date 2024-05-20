terraform {
  # required_version = ">=1.2.4, <=1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.46.0"
    }
  }
}
provider "azurerm" {
  subscription_id = var.env_subscription_id
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
  alias           = "sa_privateDNS"
  client_id       = var.client_id_privateDNS
  client_secret   = var.client_secret_privateDNS
  subscription_id = var.subscription_id_privateDNS
  features {}
}

provider "azurerm" {
  alias                      = "kv_privateDNS"
  client_id                  = var.client_id_privateDNS
  client_secret              = var.client_secret_privateDNS
  subscription_id            = var.subscription_id_kvPrivateDNS
  skip_provider_registration = true
  features {}
}