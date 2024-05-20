# Create managed identity
resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "id-${var.app_name}-${var.env_name}-${var.rg_name}"
  resource_group_name =  var.rg_name
  location            =  var.resource_location
}