resource "azurerm_storage_account" "main" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  public_network_access_enabled   = false
  local_user_enabled              = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

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
}

resource "azurerm_private_endpoint" "main" {
  name                = "${var.storage_account_name}-private-endpoint"
  resource_group_name = azurerm_storage_account.main.resource_group_name
  location            = azurerm_storage_account.main.location
  subnet_id           = var.virtual_network_subnet_ids[0]

  private_service_connection {
    name                           = "${var.storage_account_name}-private-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = var.key_vault_id
    subresource_names              = ["vault", "blob"]
  }

  depends_on = [
    azurerm_storage_account.main
  ]
}

resource "azurerm_storage_container" "main" {
  storage_account_name = azurerm_storage_account.main.name

  name = var.storage_container_name

  depends_on = [
    azurerm_storage_account.main
  ]
}

resource "azurerm_storage_account_network_rules" "main" {
  storage_account_id = azurerm_storage_account.main.id

  default_action             = "Deny"
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
  bypass                     = ["Metrics", "AzureServices"]

  depends_on = [
    azurerm_storage_account.main
  ]
}

resource "azurerm_storage_account_customer_managed_key" "main" {
  storage_account_id = azurerm_storage_account.main.id

  key_vault_id = var.key_vault_id
  key_name     = var.key_vault_key_name

  depends_on = [
    azurerm_storage_account.main
  ]
}

resource "azurerm_storage_blob" "main" {
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name

  name = var.storage_blob_name
  type = "Block"

  depends_on = [
    azurerm_storage_account.main,
    azurerm_storage_container.main
  ]
}