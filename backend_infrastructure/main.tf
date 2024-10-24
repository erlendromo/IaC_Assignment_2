module "storage" {
  source                     = "../modules/storage"
  resource_group_name        = var.resource_group_name
  resource_group_location    = var.resource_group_location
  storage_account_name       = "${var.base_prefix}sa${var.random_string}${var.workspace_suffix}"
  virtual_network_subnet_ids = var.subnet_ids
}

module "key_vault" {
  source                              = "../modules/keyvault"
  key_vault_name                      = "${var.base_prefix}-kv-${var.workspace_suffix}"
  resource_group_name                 = var.resource_group_name
  resource_group_location             = var.resource_group_location
  user_assigned_identity_tenant_id    = var.user_assigned_tenant_id
  user_assigned_identity_principal_id = var.user_assigned_principal_id
  key_vault_keys = [
    {
      name            = "sql-key"
      key_type        = "RSA-HSM"
      key_size        = 2048
      key_opts        = ["unwrapKey", "wrapKey"]
      expiration_date = "2024-12-31T23:59:00Z"
    },
    {
      name            = "storage-key"
      key_type        = "RSA-HSM"
      key_size        = 2048
      key_opts        = ["unwrapKey", "wrapKey"]
      expiration_date = "2024-12-31T23:59:00Z"
    }
  ]
  subnet_id = var.subnet_ids[0]
}

resource "azurerm_key_vault_access_policy" "cmk_access" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = var.user_assigned_tenant_id
  object_id    = module.storage.storage_account_pricipal_id

  key_permissions    = ["Get", "List", "WrapKey", "UnwrapKey"]
  secret_permissions = ["Get", "List"]

  depends_on = [
    module.key_vault,
    module.storage
  ]
}

resource "azurerm_storage_account_customer_managed_key" "main" {
  storage_account_id = module.storage.storage_account_id
  key_vault_id       = module.key_vault.key_vault_id
  key_name           = module.key_vault.key_names[1]

  depends_on = [
    module.key_vault,
    azurerm_key_vault_access_policy.cmk_access
  ]
}

module "sql_database" {
  source                              = "../modules/database"
  resource_group_name                 = var.resource_group_name
  resource_group_location             = var.resource_group_location
  server_name                         = "${var.base_prefix}-sqlserver-${var.workspace_suffix}"
  administrator_login                 = var.random_string
  administrator_login_password        = var.random_password
  storage_endpoint                    = module.storage.storage_account_blob_endpoint
  storage_account_access_key          = module.storage.storage_account_access_key
  database_name                       = "${var.base_prefix}-db-${var.workspace_suffix}"
  user_assigned_identity_principal_id = var.user_assigned_principal_id
  key_vault_key_id                    = module.key_vault.key_vault_key_ids[0]
  subnet_id                           = module.network.subnet_id_list[0]

  depends_on = [
    module.storage,
    module.key_vault
  ]
}

resource "azurerm_key_vault_access_policy" "sql_access" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = var.user_assigned_tenant_id
  object_id    = module.sql_database.sql_database_principal_id

  key_permissions    = ["Get", "List", "WrapKey", "UnwrapKey"]
  secret_permissions = ["Get", "List"]

  depends_on = [
    module.key_vault,
    module.sql_database
  ]
}