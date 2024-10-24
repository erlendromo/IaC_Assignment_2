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
  source                  = "./modules/network"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  virtual_network_name          = "${local.base_prefix}-vnet-${local.workspace_suffix}"
  virtual_network_address_space = ["10.0.0.0/24"]                    # 256 ip addresses
  dns_servers                   = ["168.63.129.16", "168.63.129.17"] # Azure-provided DNS servers
  subnets = [
    {
      name              = "subnet-1"
      address_prefixes  = ["10.0.0.0/28"] # 16 ip addresses
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
  ]
}

module "nsg" {
  source                      = "./modules/nsg"
  resource_group_name         = azurerm_resource_group.main.name
  resource_group_location     = azurerm_resource_group.main.location
  network_security_group_name = "${local.base_prefix}-nsg-${local.workspace_suffix}"
  network_security_rules = {
    "AllowHttpsInbound" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "10.0.0.0/24"
      destination_address_prefix = "*"
    },
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = module.network.subnet_id_list[0]
  network_security_group_id = module.nsg.network_security_group_id

  depends_on = [
    module.network,
    module.nsg
  ]
}

resource "azurerm_user_assigned_identity" "main" {
  name                = "${local.base_prefix}-identity-${local.workspace_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

module "key_vault" {
  source                              = "./modules/keyvault"
  key_vault_name                      = "${local.base_prefix}-kv-${local.workspace_suffix}"
  resource_group_name                 = azurerm_resource_group.main.name
  resource_group_location             = azurerm_resource_group.main.location
  user_assigned_identity_tenant_id    = azurerm_user_assigned_identity.main.tenant_id
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.main.principal_id
  key_vault_keys = [
    {
      name            = "database-key"
      key_type        = "RSA-HSM"
      key_size        = 2048
      key_opts        = ["unwrapKey", "wrapKey"]
      expiration_date = "2024-12-31T23:59:00Z"
    }
  ]
}

module "storage" {
  source                     = "./modules/storage"
  resource_group_name        = azurerm_resource_group.main.name
  resource_group_location    = azurerm_resource_group.main.location
  storage_account_name       = "${local.base_prefix}sa${random_string.main.result}${local.workspace_suffix}"
  virtual_network_subnet_ids = module.network.subnet_id_list
  key_vault_id               = module.key_vault.key_vault_id
  key_name                   = module.key_vault.key_vault_name
}

module "app_service" {
  source                     = "./modules/app_service"
  resource_group_name        = azurerm_resource_group.main.name
  resource_group_location    = azurerm_resource_group.main.location
  service_plan_name          = "${local.base_prefix}-sp-${local.workspace_suffix}"
  linux_web_app_name         = "${local.base_prefix}-webapp-${local.workspace_suffix}"
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.storage_account_access_key
}

resource "azurerm_lb" "main" {
  name                = "${local.base_prefix}-lb-${local.workspace_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"

  frontend_ip_configuration {
    name      = "EntryPoint"
    subnet_id = module.network.subnet_id_list[0]
  }

  depends_on = [
    module.network
  ]
}

module "sql_database" {
  source                       = "./modules/database"
  resource_group_name          = azurerm_resource_group.main.name
  resource_group_location      = azurerm_resource_group.main.location
  server_name                  = "${local.base_prefix}-sql-server-${local.workspace_suffix}"
  administrator_login          = random_string.main.result
  administrator_login_password = random_password.main.result
  storage_endpoint             = module.storage.storage_account_blob_endpoint
  storage_account_access_key   = module.storage.storage_account_access_key
  database_name                = "${local.base_prefix}-db-${local.workspace_suffix}"
  user_assigned_identity_id    = azurerm_user_assigned_identity.main.id
  key_vault_key_id             = module.key_vault.key_vault_key_ids[0]
  subnet_id                    = module.network.subnet_id_list[0]
}