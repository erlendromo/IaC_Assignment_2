output "storage_account_blob_endpoint" {
  value       = azurerm_storage_account.main.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the storage account."
}

output "storage_account_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
}

output "storage_account_name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the storage account."
}

output "storage_account_pricipal_id" {
  value       = azurerm_storage_account.main.identity[0].principal_id
  description = "The principal ID of the storage account."
}

output "storage_account_id" {
  value       = azurerm_storage_account.main.id
  description = "The ID of the storage account."
}