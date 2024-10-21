output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the Key Vault."
}

output "key_vault_key_name" {
  value       = azurerm_key_vault_key.main.name
  description = "The name of the Key Vault Key."
}