output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the key vault."
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "The name of the key vault."
}

output "key_vault_key_ids" {
  value       = tolist([for key in azurerm_key_vault_key.main : key.id])
  description = "The IDs of the key vault keys."
}

output "key_names" {
  value       = tolist([for key in azurerm_key_vault_key.main : key.name])
  description = "The names of the key vault keys."
}

output "key_vault_key_principal_ids" {
  value       = tolist([for key in azurerm_azurerm_key_vault_key.main : key.principal_id])
  description = "The principal IDs of the key vault keys."
}