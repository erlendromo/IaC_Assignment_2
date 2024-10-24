resource "azurerm_storage_account" "main" {
  name                       = var.storage_account_name
  resource_group_name        = var.resource_group_name
  location                   = var.resource_group_location
  account_tier               = var.account_tier
  account_kind               = var.account_kind
  account_replication_type   = var.account_replication_type
  https_traffic_only_enabled = var.https_traffic_only_enabled

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }
}