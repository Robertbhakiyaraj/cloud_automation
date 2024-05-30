### Keyvault Creation ###

module "cloud_keyvault" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/keyvault/azurerm"
  version = "1.2.2" # Example.  Choose the latest version

  providers = {
    azurerm.kv_privateDNS = azurerm.kv_privateDNS
  }

  resource_group_name             = var.vnet_resourcegroup_name  #"rg-${var.app_name}-${var.env_name}-${var.rg_name}-${var.location}"
  kv_name                         = "kv-${var.app_name}-${var.env_name}-${var.rg_name}"
  sku_name                        = "standard"
  keyvault_location               = var.location
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = false
  purge_protection_enabled        = true   # module.create_subnets["keyvault"].subnet_details.subnet_id 
  pe_subnet_id                    = var.subnet_map["keyvault"].subnet_details.subnet_id   #data.azurerm_subnet.kv_subnet.id

  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = [] # (Optional) One or more IP Addresses in this format "<your ip 1>", "your ip 2>"), or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet_ids =  [var.subnet_map["keyvault"].subnet_details.subnet_id]
  }

  access_policies = {
   
  }

  kv_additional_tags = {
    iac = "Terraform"
    env = "${var.env_name}"
  }
}

resource "azurerm_key_vault_access_policy" "cloud_keyvault_accesspolicy" {
  key_vault_id = module.cloud_keyvault.key_vault.id
  tenant_id    = data.azurerm_client_config.current_config.tenant_id
  object_id    = var.managed_principal_id    #.managed_identity.principal_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Encrypt", "Decrypt", "WrapKey", "UnwrapKey"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]
  storage_permissions = ["Get", "List"]
}
