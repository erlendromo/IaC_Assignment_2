module "storage" {
  source                     = "../modules/storage"
  resource_group_name        = var.resource_group_name
  resource_group_location    = var.resource_group_location
  virtual_network_subnet_ids = var.subnet_ids

  storage_account_name = "${var.base_prefix}sa${var.random_string}${var.workspace_suffix}"
}

module "key_vault" {
  source                              = "../modules/keyvault"
  resource_group_name                 = var.resource_group_name
  resource_group_location             = var.resource_group_location
  user_assigned_identity_tenant_id    = var.user_assigned_tenant_id
  user_assigned_identity_principal_id = var.user_assigned_principal_id
  subnet_id                           = var.subnet_ids[0]
  storage_account_id                  = module.storage.storage_account_id

  key_vault_name = "${var.base_prefix}-kv-${var.workspace_suffix}"
  key_vault_keys = [
    {
      name            = "storage-key"
      key_type        = "RSA-HSM"
      key_size        = 2048
      key_opts        = ["unwrapKey", "wrapKey"]
      expiration_date = "2024-12-31T23:59:00Z"
    },
    {
      name            = "sql-key"
      key_type        = "RSA-HSM"
      key_size        = 2048
      key_opts        = ["unwrapKey", "wrapKey"]
      expiration_date = "2024-12-31T23:59:00Z"
    }
  ]

  depends_on = [
    module.storage
  ]
}

module "sql_database" {
  source                              = "../modules/database"
  resource_group_name                 = var.resource_group_name
  resource_group_location             = var.resource_group_location
  administrator_login                 = var.random_string
  administrator_login_password        = var.random_password
  user_assigned_identity_principal_id = var.user_assigned_principal_id
  subnet_id                           = var.subnet_ids[0]

  server_name   = "${var.base_prefix}-sqlserver-${var.workspace_suffix}"
  database_name = "${var.base_prefix}-db-${var.workspace_suffix}"

  storage_endpoint           = module.storage.storage_account_blob_endpoint
  storage_account_access_key = module.storage.storage_account_access_key
  key_vault_key_id           = module.key_vault.key_vault_key_ids[1]

  depends_on = [
    module.storage,
    module.key_vault
  ]
}