#Output for Oracle

output "storage_account_tier_oracle" {
  value = data.azurerm_storage_account.storage-account-oracle.account_tier
}

output "primary_file_internet_endpoint_oracle" {
  value = data.azurerm_storage_account.storage-account-oracle.primary_file_internet_endpoint
}

output "primary_file_host_oracle" {
  value = data.azurerm_storage_account.storage-account-oracle.primary_file_host
}

output "primary_file_endpoint_oracle" {
  value = data.azurerm_storage_account.storage-account-oracle.primary_file_endpoint
}

output "primary_dfs_internet_endpoint_oracle" {
  value = data.azurerm_storage_account.storage-account-oracle.primary_dfs_internet_endpoint
}

output "primary_dfs_endpoint_oracle" {
  value = data.azurerm_storage_account.storage-account-oracle.primary_dfs_endpoint
}


#Output for AutoSyS

output "storage_account_tier_autosys" {
  value = data.azurerm_storage_account.storage-account-autosys.account_tier
}

output "primary_file_internet_endpoint_autosys" {
  value = data.azurerm_storage_account.storage-account-autosys.primary_file_internet_endpoint
}

output "primary_file_host_autosys" {
  value = data.azurerm_storage_account.storage-account-autosys.primary_file_host
}

output "primary_file_endpoint_autosys" {
  value = data.azurerm_storage_account.storage-account-autosys.primary_file_endpoint
}

output "primary_dfs_internet_endpoint_autosys" {
  value = data.azurerm_storage_account.storage-account-autosys.primary_dfs_internet_endpoint
}

output "primary_dfs_endpoint_autosys" {
  value = data.azurerm_storage_account.storage-account-autosys.primary_dfs_endpoint
}


output "file_share_ids_autosys" {
  value = module.storage_account_fileshare.file_share_ids
}

output "file_share_urls_autosys" {
  value = module.storage_account_fileshare.file_share_urls
}

# output "sa_ids_autosys" {
#   value = module.storage_account_fileshare.sa_ids
# }