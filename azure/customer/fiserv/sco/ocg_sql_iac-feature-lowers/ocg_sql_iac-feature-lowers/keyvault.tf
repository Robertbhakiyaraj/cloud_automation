## Modules ##
# Generate random key suffix
resource "random_string" "key_suffix_sql01" {
  length  = 5
  special = false
  upper   = true
  numeric = true
}

# Keyvault for SQL DB
# module "kv_sql01_cus" {
#   source  = "jlqpztfe01.onefiserv.net/fiserv-main/keyvault/azurerm"
#   version = "1.2.1"

#   providers = {
#     azurerm.kv_privateDNS = azurerm.kv_privateDNS
#   }

#   resource_group_name             = module.rg_sql01_cus.name
#   kv_name                         = var.sql_stack["sql01"].keyvault.kv_name_cus
#   sku_name                        = "standard"
#   keyvault_location               = module.rg_sql01_cus.location
#   enabled_for_deployment          = true
#   enabled_for_disk_encryption     = true
#   enabled_for_template_deployment = false
#   purge_protection_enabled        = true
#   pe_subnet_id                    = module.subnet_net01.subnet_id[0]

#   network_acls = {
#     bypass                     = "AzureServices"
#     default_action             = "Deny"
#     ip_rules                   = []
#     virtual_network_subnet_ids = [module.subnet_net01.subnet_id[0]]
#   }

#   access_policies = {
#   }

#   kv_additional_tags = {
#     iac = "Terraform"
#     env = var.sql_stack["sql01"].environment.sql_env
#   }
# }
# resource "azurerm_key_vault_access_policy" "ap-mi-sql01-kv-cus" {
#   key_vault_id = module.kv_sql01_cus.key_vault.id
#   tenant_id    = data.azurerm_client_config.current_config.tenant_id
#   object_id    = azurerm_user_assigned_identity.id-sql01-cus.principal_id

#   key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Encrypt", "Decrypt", "WrapKey", "UnwrapKey"]
#   secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
#   certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]

#   storage_permissions = ["Get", "List"]
#   depends_on = [
#     module.kv_sql01_cus
#   ]
# }

module "kv_sql01_eus2" {
  source  = "jlqpztfe01.onefiserv.net/fiserv-main/keyvault/azurerm"
  version = "1.2.1"

  providers = {
    azurerm.kv_privateDNS = azurerm.kv_privateDNS
  }

  resource_group_name             = module.rg_sql01_eus2.name
  kv_name                         = var.sql_stack["sql01"].keyvault.kv_name_eus2
  sku_name                        = "standard"
  keyvault_location               = module.rg_sql01_eus2.location
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = false
  purge_protection_enabled        = true
  pe_subnet_id                    = module.subnet_net01.subnet_id[0]

  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = [] # (Optional) One or more IP Addresses in this format "<your ip 1>", "your ip 2>"), or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet_ids = [module.subnet_net01.subnet_id[0]]
  }

  access_policies = {
  }

  kv_additional_tags = {
    iac = "Terraform"
    env = var.sql_stack["sql01"].environment.sql_env
  }
}
resource "azurerm_key_vault_access_policy" "ap-mi-sql01-kv-eus2" {
  key_vault_id = module.kv_sql01_eus2.key_vault.id
  tenant_id    = data.azurerm_client_config.current_config.tenant_id
  object_id    = azurerm_user_assigned_identity.id-sql01-eus2.principal_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Encrypt", "Decrypt", "WrapKey", "UnwrapKey"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]

  storage_permissions = ["Get", "List"]
  depends_on = [
    module.kv_sql01_eus2
  ]
}

# Disk Encryption Set
# resource "azurerm_key_vault_key" "des_key_sql01_cus" {
#   name         = "${var.sql_stack["sql01"].identity.des_key_name_cus}-${random_string.key_suffix_sql01.result}"
#   key_vault_id = module.kv_sql01_cus.key_vault_id
#   key_type     = "RSA"
#   key_size     = 2048
#   key_opts = [
#     "decrypt",
#     "encrypt",
#     "unwrapKey",
#     "wrapKey",
#   ]
#   depends_on = [
#     module.kv_sql01_cus,
#     azurerm_key_vault_access_policy.ap-mi-sql01-kv-cus
#   ]
# }
# resource "azurerm_disk_encryption_set" "des_sql01_cus" {
#   name                = var.sql_stack["sql01"].identity.des_name_cus
#   resource_group_name = module.rg_sql01_cus.name
#   location            = module.rg_sql01_cus.location
#   key_vault_key_id    = azurerm_key_vault_key.des_key_sql01_cus.id

#   identity {
#     type = "UserAssigned"
#     identity_ids = [
#       azurerm_user_assigned_identity.id-sql01-cus.id
#     ]
#   }
#   depends_on = [
#     module.kv_sql01_cus,
#     azurerm_key_vault_access_policy.ap-mi-sql01-kv-cus
#   ]
# }
resource "azurerm_key_vault_key" "des_key_sql01_eus2" {
  name         = "${var.sql_stack["sql01"].identity.des_key_name_eus2}-${random_string.key_suffix_sql01.result}"
  key_vault_id = module.kv_sql01_eus2.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "unwrapKey",
    "wrapKey",
  ]
  depends_on = [
    module.kv_sql01_eus2,
    azurerm_key_vault_access_policy.ap-mi-sql01-kv-eus2
  ]
}
resource "azurerm_disk_encryption_set" "des_sql01_eus2" {
  name                = var.sql_stack["sql01"].identity.des_name_eus2
  resource_group_name = module.rg_sql01_eus2.name
  location            = module.rg_sql01_eus2.location
  key_vault_key_id    = azurerm_key_vault_key.des_key_sql01_eus2.id

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.id-sql01-eus2.id
    ]
  }
  depends_on = [
    module.kv_sql01_eus2,
    azurerm_key_vault_access_policy.ap-mi-sql01-kv-eus2
  ]
}
