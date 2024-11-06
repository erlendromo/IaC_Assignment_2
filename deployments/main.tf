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
  resource_group_location = azurerm_resource_group.main.location

  virtual_network_name          = "${local.base_prefix}-vnet-${local.workspace_suffix}"
  virtual_network_address_space = ["10.0.0.0/16"]

  subnets = {
    "subnet1" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
  }

  network_security_group_name = "${local.base_prefix}-nsg-${local.workspace_suffix}"

  network_security_rules = {
    "AllowHttpsInbound" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
    },
    "AllowHttpInbound" = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.0.0.0/16"
      destination_address_prefix = "*"
    },
    "AllowAppGatewayInbound" = {
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "65200-65535"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }

  depends_on = [
    azurerm_resource_group.main
  ]
}

module "storage" {
  source                  = "../modules/storage"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  storage_account_name = "${local.base_prefix}sa${random_string.main.result}${local.workspace_suffix}"

  depends_on = [
    azurerm_resource_group.main,
    random_string.main
  ]
}

module "database" {
  source                  = "../modules/database"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

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
  source                  = "../modules/app_service"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  service_plan_name = "${local.base_prefix}-asp-${local.workspace_suffix}"

  linux_web_app_name = "${local.base_prefix}-web-${local.workspace_suffix}"

  subnet_cidr_range = "10.0.0.0/16"

  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.storage_account_access_key

  pip_name = "${local.base_prefix}-webapp-pip-${local.workspace_suffix}"

  application_gateway_name      = "${local.base_prefix}-appgw-${local.workspace_suffix}"
  application_gateway_subnet_id = module.network.subnet_id_map.subnet1

  depends_on = [
    azurerm_resource_group.main,
    module.network,
    module.storage
  ]
}

# Test deployment