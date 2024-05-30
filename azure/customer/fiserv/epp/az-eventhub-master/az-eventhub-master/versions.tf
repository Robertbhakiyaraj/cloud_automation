terraform {
  required_version = "~> 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.30"
    }
  }
}

provider "azurerm" {
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
