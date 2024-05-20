output "key_vault_id" {
    value = module.cloud_keyvault.key_vault_id
}

output "resource_group_name" {
  value = module.cloud_keyvault.resource_group_name
}

output "kv_name" {
  description = "The Name of the Key Vault"
  value       = module.cloud_keyvault.kv_name
}

