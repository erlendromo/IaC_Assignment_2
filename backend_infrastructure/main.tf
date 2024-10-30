module "storage" {
  source                  = "../modules/storage"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location

  storage_account_name = "${var.base_prefix}sa${var.random_string}${var.workspace_suffix}"
}

module "sql_database" {
  source                       = "../modules/database"
  resource_group_name          = var.resource_group_name
  resource_group_location      = var.resource_group_location
  administrator_login          = var.random_string
  administrator_login_password = var.random_password

  server_name   = "${var.base_prefix}-sqlserver-${var.workspace_suffix}"
  database_name = "${var.base_prefix}-db-${var.workspace_suffix}"

  depends_on = [
    module.storage,
    module.key_vault
  ]
}

module "app_service" {
  source                     = "../modules/app_service"
  resource_group_name        = var.resource_group_name
  resource_group_location    = var.resource_group_location
  service_plan_name          = "${var.base_prefix}-sp-${var.workspace_suffix}"
  linux_web_app_name         = "${var.base_prefix}-webapp-${var.workspace_suffix}"
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.storage_account_access_key

  depends_on = [
    module.storage
  ]
}