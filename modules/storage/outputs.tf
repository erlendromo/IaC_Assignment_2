output "storage_account_primary_access_key" {
  value = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
}