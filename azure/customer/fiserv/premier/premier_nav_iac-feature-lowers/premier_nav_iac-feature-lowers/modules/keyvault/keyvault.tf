
## Modules ##
# Generate random key suffix
resource "random_string" "key_suffix_db" {
  length  = 5
  special = false
  upper   = true
  numeric = true
}

### Keyvault Creation ###

module "kv_des_cus" {
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

resource "azurerm_key_vault_access_policy" "ap-mi-des-kv" {
  key_vault_id = module.kv_des_cus.key_vault.id
  tenant_id    = data.azurerm_client_config.current_config.tenant_id
  object_id    = var.managed_principal_id    #.managed_identity.principal_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Encrypt", "Decrypt", "WrapKey", "UnwrapKey"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]
  storage_permissions = ["Get", "List"]
}


resource "azurerm_key_vault_key" "des_key_app" {
  name         = "key-${var.app_name}-${var.env_name}-${var.rg_name}-${random_string.key_suffix_db.result}"
  key_vault_id = module.kv_des_cus.key_vault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "unwrapKey",
    "wrapKey",
  ]
  depends_on = [
    module.kv_des_cus,
    azurerm_key_vault_access_policy.ap-mi-des-kv
  ]
}
resource "azurerm_disk_encryption_set" "des_app" {
  name                = "key-${var.app_name}-${var.env_name}-${var.rg_name}"
  resource_group_name = var.vnet_resourcegroup_name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.des_key_app.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.user_assigned_id
    ]
  }
  depends_on = [
    module.kv_des_cus,
    azurerm_key_vault_access_policy.ap-mi-des-kv
  ]
}
