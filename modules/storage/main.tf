resource "azurerm_storage_account" "main" {
  name                       = var.storage_account_name
  resource_group_name        = var.resource_group_name
  location                   = var.resource_group_location
  account_tier               = var.account_tier
  account_kind               = var.account_kind
  account_replication_type   = var.account_replication_type
  https_traffic_only_enabled = var.https_traffic_only_enabled
  min_tls_version            = var.min_tls_version
}

resource "azurerm_storage_account_network_rules" "default" {
  storage_account_id         = azurerm_storage_account.main.id
  default_action             = "Deny"
  ip_rules                   = ["100.0.0.1"]
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
  bypass                     = ["Metrics", "AzureServices"]
}

resource "azurerm_storage_account_network_rules" "localhost" {
  storage_account_id         = azurerm_storage_account.main.id
  default_action             = "Deny"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
  bypass                     = ["Metrics", "AzureServices"]
}