data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                          = var.key_vault_name
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  public_network_access_enabled = false
  soft_delete_retention_days    = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.public_ip_rules
  }
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  secret_permissions      = ["Get", "Set", "Delete", "List", "Restore", "Recover", "Purge"]
  certificate_permissions = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  storage_permissions     = ["Get", "List", "Delete", "Set", "Update", "RegenerateKey", "Recover", "Backup", "Restore", "Purge"]
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

resource "azurerm_private_endpoint" "main" {
  name                = var.private_endpoint_name
  resource_group_name = azurerm_key_vault.main.resource_group_name
  location            = azurerm_key_vault.main.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
  }
}