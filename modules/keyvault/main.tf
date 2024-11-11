data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name = var.keyvault_name
  resource_group_name = var.resource_group_name
  location = var.location
  tenant_id = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled = var.purge_protection_enabled
  sku_name = var.sku_name

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = var.key_permissions
  storage_permissions = var.storage_permissions
  secret_permissions = var.secret_permissions
  certificate_permissions = var.certificate_permissions

  depends_on = [
    azurerm_key_vault.main
  ]
}

resource "azurerm_key_vault_secret" "sa_backend_accesskey" {
  key_vault_id = azurerm_key_vault.main.id
  name = var.sa_backend_accesskey_name
  value = var.sa_backend_accesskey

  tags = var.tags

  depends_on = [
    azurerm_key_vault.main,
    azurerm_key_vault_access_policy.main
  ]
}