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

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    azurerm_mssql_server.main
  ]
}