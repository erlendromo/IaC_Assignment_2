output "storage_account_name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the storage account."
}

output "storage_account_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "storage_blob_endpoint" {
  value       = azurerm_storage_account.main.primary_blob_endpoint
  description = "The blob endpoint for the storage account."
}
