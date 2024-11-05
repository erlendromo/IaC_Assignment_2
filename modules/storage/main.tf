resource "azurerm_storage_account" "main" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  account_tier                    = var.account_tier
  account_kind                    = var.account_kind
  account_replication_type        = var.account_replication_type
  https_traffic_only_enabled      = var.https_traffic_only_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  public_network_access_enabled   = var.public_network_access_enabled
  shared_access_key_enabled       = var.shared_access_key_enabled
  local_user_enabled              = var.local_user_enabled
  min_tls_version                 = var.min_tls_version
}

resource "azurerm_storage_container" "main" {
  name                  = var.container_name
  storage_account_name = azurerm_storage_account.main.name
  container_access_type = var.container_access_type

  depends_on = [
    azurerm_storage_account.main
  ]
}