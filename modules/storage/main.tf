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
  shared_access_key_enabled       = var.shared_access_key_enabled # TODO be wary of this
  min_tls_version                 = var.min_tls_version

  queue_properties {
    logging {
      read                  = true
      write                 = true
      delete                = true
      version               = "1.0"
      retention_policy_days = 10
    }

    hour_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 10
    }

    minute_metrics {
      enabled               = true
      include_apis          = true
      version               = "1.0"
      retention_policy_days = 10
    }
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
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