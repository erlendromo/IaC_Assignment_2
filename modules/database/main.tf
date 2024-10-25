data "azurerm_client_config" "current" {}

resource "azurerm_mssql_server" "main" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = var.minimum_tls_version

  azuread_administrator {
    login_username = "sqlserveradmin"
    object_id      = data.azurerm_client_config.current.object_id
    tenant_id      = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  server_id                  = azurerm_mssql_server.main.id
  storage_endpoint           = var.storage_endpoint
  storage_account_access_key = var.storage_account_access_key
  retention_in_days          = var.retention_in_days

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  depends_on = [
    azurerm_mssql_server.main
  ]
}

resource "azurerm_private_endpoint" "main" {
  name                = "sql-private-endpoint"
  resource_group_name = azurerm_mssql_server.main.resource_group_name
  location            = azurerm_mssql_server.main.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "sql-private-endpoint-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  depends_on = [
    azurerm_mssql_server.main
  ]
}

resource "azurerm_mssql_database" "main" {
  server_id      = azurerm_mssql_server.main.id
  name           = var.database_name
  collation      = var.collation
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  read_scale     = var.read_scale_enabled
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  enclave_type   = var.enclave_type
  ledger_enabled = var.ledger_enabled
  transparent_data_encryption_key_vault_key_id = var.key_vault_key_id

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    azurerm_mssql_server.main,
    azurerm_private_endpoint.main
  ]
}