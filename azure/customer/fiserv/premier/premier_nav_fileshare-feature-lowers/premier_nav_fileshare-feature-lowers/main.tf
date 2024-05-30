terraform {
  backend "remote" {
    hostname     = "jlqpztfe01.onefiserv.net"
    organization = "fiserv-main"

    workspaces {
      name = "premier_nav_storage_lowers"
    }
  }
}

locals {
  storage_name = lower(replace("stgacct${var.app_name}${var.env_name}" , "-" , ""))
}

module "App_FileShare" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/storageaccount/azurerm"
  version = "1.2.1"

  key_vault_id            = data.azurerm_key_vault.existing_keyvault.id
  key_vault_key           = null

  providers = {
    azurerm.sa_privateDNS = azurerm.sa_privateDNS
  }

  pe_subnet_id = data.azurerm_subnet.existing_subnet.id

  storage_accounts = {
    sa1 = {
      name                    = local.storage_name
      resource_group_name     = var.vnet_resourcegroup_name
      resource_group_location = var.location
      sku                     = "Standard_RAGRS"
      account_kind            = "FileStorage"
      access_tier             = null
      public_network_access_enabled = false
      network_rules = {
        "bypass"                     = ["AzureServices"],
        "default_action"             = "Deny",
        "ip_rules"                   = [], # Ex: "204.194.140.0/22", "136.226.2.209", "104.129.205.95"
        "virtual_network_subnet_ids" = []
      }
    }
  }

  file_shares = {
    share1 = {
      name                 = "${var.filestorage_name}-fileshare"
      storage_account_name = local.storage_name
      quota                = "256"
      enabled_protocol     = "SMB"
    }
  }

  sa_additional_tags = {
    iac = "Terraform"
  }
}
