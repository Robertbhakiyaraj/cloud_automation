
# Managed Identity
# resource "azurerm_user_assigned_identity" "id-sql01-cus" {
#   name                = var.sql_stack["sql01"].identity.mi_name_cus
#   resource_group_name = module.rg_sql01_cus.name
#   location            = module.rg_sql01_cus.location
# }
resource "azurerm_user_assigned_identity" "id-sql01-eus2" {
  name                = var.sql_stack["sql01"].identity.mi_name_eus2
  resource_group_name = module.rg_sql01_eus2.name
  location            = module.rg_sql01_eus2.location
}

