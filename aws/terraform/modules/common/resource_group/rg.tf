terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = var.name
  location = var.location
}