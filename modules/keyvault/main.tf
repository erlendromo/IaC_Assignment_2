data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name = var.key_vault_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault_key" "main" {
  key_vault_id = azurerm_key_vault.main.id

  name = var.key_vault_key_name
  key_type = var.key_vault_key_type
  key_opts = var.key_vault_key_opts

  depends_on = [
    azurerm_key_vault.main
  ]
}