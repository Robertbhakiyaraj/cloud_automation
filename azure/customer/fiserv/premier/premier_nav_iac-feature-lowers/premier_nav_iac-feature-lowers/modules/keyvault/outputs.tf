output "key_vault_id" {
    value = module.kv_des_cus.key_vault_id
}

output "resource_group_name" {
  value = module.kv_des_cus.resource_group_name
}

output "kv_name" {
  description = "The Name of the Key Vault"
  value       = module.kv_des_cus.kv_name
}

output "des_name" {
    value = azurerm_disk_encryption_set.des_app.name
}

# output "disk_encryption_set_resource_group_name" {
#     value = azurerm_disk_encryption_set.des_db_eus2.name.resource_group_name
# }

output "name_id" {
    value = azurerm_disk_encryption_set.des_app.id
}

output "key_name" {
    value = azurerm_key_vault_key.des_key_app.name
}

output "versionless_id" {
    value = azurerm_key_vault_key.des_key_app.versionless_id
}


