resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}

resource "random_password" "main" {
  length           = 16
  override_special = "!@#$%^&*()_+"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location
}



module "network" {
  source                  = "../modules/network"
  resource_group_name     = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location

  virtual_network_name          = "${local.base_prefix}-vnet-${local.workspace_suffix}"
  virtual_network_address_space = ["10.0.0.0/16"]

  subnets = {
    "main-subnet" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = []
    },
    "app-subnet" = {
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  }

  depends_on = [
    azurerm_resource_group.main
  ]
}

module "storage" {
  source                  = "../modules/storage"
  resource_group_name     = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location

  storage_account_name = "${local.base_prefix}sa${random_string.main.result}${local.workspace_suffix}"
  tags = local.tags

  depends_on = [
    azurerm_resource_group.main,
    random_string.main
  ]
}

module "database" {
  source                  = "../modules/database"
  resource_group_name     = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location

  server_name                  = "${local.base_prefix}-sqlserver-${local.workspace_suffix}"
  administrator_login          = random_string.main.result
  administrator_login_password = random_password.main.result

  database_name = "${local.base_prefix}-sqldb-${local.workspace_suffix}"

  storage_account_access_key = module.storage.storage_account_access_key
  storage_endpoint           = module.storage.storage_blob_endpoint

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

  service_plan_name = "${local.base_prefix}-asp-${local.workspace_suffix}"

  linux_web_app_name            = "${local.base_prefix}-web-${local.workspace_suffix}"
  https_only                    = false
  public_network_access_enabled = true
  client_certificate_enabled    = false

  subnet_cidr_range = "10.0.2.0/24"

  storage_container_name     = module.storage.storage_container_name
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.storage_account_access_key

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

  pip_name = "${local.base_prefix}-appgw-pip-${local.workspace_suffix}"

  application_gateway_name = "${local.base_prefix}-appgw-${local.workspace_suffix}"
  gateway_ip_configuration = {
    name      = "appgwIPConfig"
    subnet_id = module.network.subnet_id_map.app-subnet
  }
  gateway_frontend_ip_configuration_name = "appgwFrontendIPConfig"
  gateway_backend_address_pool = {
    name = "appgwBackendAddressPool"
    fqdns = [
      module.appservice.web_app_slot_hostname
    ]
  }

  depends_on = [
    azurerm_resource_group.main,
    module.network,
    module.appservice
  ]
}
