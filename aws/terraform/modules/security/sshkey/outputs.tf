output "sshkey_public" {
    value = var.azurerm_key_vault_name ?  data.azurerm_key_vault_key.ssh_key.public_key_openssh : tls_private_key.example_ssh.public_key_openssh         
}

output "sshkey_private" {
    value = tls_private_key.example_ssh.private_key_openssh
}
