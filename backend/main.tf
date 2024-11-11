resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name = format("%s%s",
    local.base_prefix,
    var.storage_account_name
  )
  container_name = format("%s-%s",
    local.base_prefix,
    var.container_name
  )

  tags = local.tags

  depends_on = [
    azurerm_resource_group.main
  ]
}

module "keyvault" {
  source              = "../modules/keyvault"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  keyvault_name = format("%s%s",
    local.base_prefix,
    var.keyvault_name
  )
  sa_backend_accesskey_name = var.sa_backend_accesskey_name
  sa_backend_accesskey      = module.storage.storage_account_access_key

  tags = local.tags

  depends_on = [
    azurerm_resource_group.main,
    module.storage
  ]
}
