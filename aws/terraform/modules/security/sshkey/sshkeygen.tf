terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

resource "tls_private_key" "example_ssh" {
    algorithm = "RSA"
    rsa_bits = 4096
}