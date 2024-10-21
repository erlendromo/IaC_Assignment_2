data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  resource_group_name         = var.resource_group_name
  location                    = var.resource_group_location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true
  public_network_access_enabled = false
  soft_delete_retention_days  = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_key" "main" {
  key_vault_id = azurerm_key_vault.main.id

  name            = var.key_vault_key_name
  key_type        = "RSA-HSM"
  key_opts        = ["decrypt", "encrypt", "sign", "wrapKey", "unwrapKey", "verify"]
  key_size        = 2048
  expiration_date = "2024-12-31T23:59:59+00:00"

  depends_on = [
    azurerm_key_vault.main
  ]
}