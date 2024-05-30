output "id" {
    value = module.resourcegroups.id
}

output "name" {
    value = module.resourcegroups.name
}

output "location" {
  description = "Location in which the resource group was created"
  value       = module.resourcegroups.location
}
