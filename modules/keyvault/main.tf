data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                          = var.key_vault_name
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  tenant_id                     = var.user_assigned_identity_tenant_id
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  public_network_access_enabled = var.public_network_access_enabled
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = ["Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy"]
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_access_policy" "user_assigned" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = var.user_assigned_identity_tenant_id
  object_id    = var.user_assigned_identity_principal_id

  key_permissions = ["Get", "List", "WrapKey", "UnwrapKey"]
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_key" "main" {
  count = length(var.key_vault_keys)

  key_vault_id    = azurerm_key_vault.main.id
  name            = var.key_vault_keys[count.index].name
  key_type        = var.key_vault_keys[count.index].key_type
  key_size        = var.key_vault_keys[count.index].key_size
  key_opts        = var.key_vault_keys[count.index].key_opts
  expiration_date = var.key_vault_keys[count.index].expiration_date
}

resource "azurerm_private_endpoint" "main" {
  name                = "keyvault-private-endpoint"
  resource_group_name = azurerm_key_vault.main.resource_group_name
  location            = azurerm_key_vault.main.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "keyvault-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}