subscription_id            = ""
vnet_name                  = ""
vnet_resourcegroup_name    = ""
keyvault_rg                = ""
keyvault_name              = ""
storage_rg                 = ""
subnet_name                = ""

app_name                   = ""
env_name                   = ""
apm_number                 = ""
hostname_prefix            = ""

storage_account_bring_cmk  = false

storage_account_specs_db = {
  sa1 = {
      name                           = ""
      resource_group_name            = ""
      location                       = ""
      resource_group_location        = ""
      sku                            = ""
      account_kind                   =  null 
      access_tier                    =  null
      public_network_access_enabled  = "false" 
      is_hns_enabled	               = "true"
      sftp_enabled                   = "true"
      network_rules = {
        "bypass"                     = ["AzureServices"],
        "default_action"             = "Deny",
        "ip_rules"                   = [], 
        "virtual_network_subnet_ids" = []
      }
    }
}

containers_specs = {
    container1 = {
      name                 = ""
      storage_account_name = ""
    }
  }

blobs_specs = {
    blob1 = {
      name                   = ""
      storage_account_name   = ""
      storage_container_name = ""
      type                   = "Block"
      size                   = 0
      content_type           = ""
      source_uri             = ""
      metadata               = {}
    }
}



storage_account_specs_apps = {
    sa1 = {
      name                           = "epplowerappssaa"
      resource_group_name            = "rg-rsv-epp-btat2"
      resource_group_location        = "Central US"
      location                       = "Central US"
      sku                            = "Premium_LRS"
      account_kind                   = "FileStorage"
      access_tier                    = "Hot"
      public_network_access_enabled  = "false"
      network_rules = {
        "bypass"                     = ["AzureServices"],
        "default_action"             = "Deny",
        "ip_rules"                   = [], 
        "virtual_network_subnet_ids" = []
      }
    }
 
}

file_share_specs = {
    fileshare1 = {
      storage_account_name = "epplowerappssaa"
      name                 = "epplowerappsfs" 
      quota                = "1024"
      enabled_protocol     = "NFS"
    }
}




