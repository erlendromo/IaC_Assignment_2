resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location

  tags = local.tags
}



module "network" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  virtual_network_name          = local.virtual_network_name
  virtual_network_address_space = var.virtual_network_address_space
  subnets = var.subnets

  tags = local.tags

  depends_on = [
    azurerm_resource_group.main
  ]
}

module "storage" {
  source              = "../modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name = local.storage_account_name

  tags                 = local.tags

  depends_on = [
    azurerm_resource_group.main,
    random_string.main
  ]
}

module "database" {
  source              = "../modules/database"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  server_name                  = local.server_name
  database_name = local.database_name
  administrator_login          = var.mssql_administrator_login
  administrator_login_password = var.mssql_administrator_login_password

  storage_account_access_key = module.storage.storage_account_access_key
  storage_endpoint           = module.storage.storage_blob_endpoint

  tags = local.tags

  depends_on = [
    azurerm_resource_group.main,
    random_string.main,
    random_password.main,
    module.network,
    module.storage
  ]
}

module "appservice" {
  source              = "../modules/app_service"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  service_plan_name = local.service_plan_name
  linux_web_app_name            = local.linux_web_app_name

  storage_container_name     = module.storage.storage_container_name
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.storage_account_access_key

  tags = local.tags

  depends_on = [
    azurerm_resource_group.main,
    module.network,
    module.storage
  ]
}

module "appgateway" {
  source              = "../modules/app_gateway"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  pip_name = local.pip_name
  application_gateway_name = local.application_gateway_name
  gateway_ip_configuration = {
    name      = var.gateway_ip_configuration_name
    subnet_id = module.network.subnet_id_map.app-subnet
  }
  gateway_frontend_ip_configuration_name = var.gateway_frontend_ip_configuration_name
  gateway_backend_address_pool = {
    name = var.gateway_backend_address_pool_name
    fqdns = [
      module.appservice.web_app_slot_hostname
    ]
  }

  tags = local.tags

  depends_on = [
    azurerm_resource_group.main,
    module.network,
    module.appservice
  ]
}
