resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
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
      name              = "subnet-${random_string.main.result}"
      address_prefixes  = ["10.0.0.0/28"] # 16 ip addresses
      service_endpoints = ["Microsoft.KeyVault"]
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

module "keyvault" {
  source                          = "./modules/keyvault"
  resource_group_name             = azurerm_resource_group.main.name
  resource_group_location         = azurerm_resource_group.main.location
  key_vault_name                  = "${local.base_prefix}-kv-${random_string.main.result}-${local.workspace_suffix}"
  key_vault_key_name              = "${local.base_prefix}-cmk-${random_string.main.result}-${local.workspace_suffix}"
  public_ip_rules                 = ["203.0.113.16/30"]
  private_endpoint_name           = "${local.base_prefix}-pe-${local.workspace_suffix}"
  subnet_id                       = module.network.subnet_id_list[0]
  private_service_connection_name = "${local.base_prefix}-psc-${local.workspace_suffix}"

  depends_on = [
    module.network
  ]
}

module "storage" {
  source                          = "./modules/storage"
  resource_group_name             = azurerm_resource_group.main.name
  resource_group_location         = azurerm_resource_group.main.location
  storage_account_name            = "${local.base_prefix}sa${random_string.main.result}${local.workspace_suffix}"
  storage_container_name          = "${local.base_prefix}sc${random_string.main.result}${local.workspace_suffix}"
  storage_blob_name               = "${local.base_prefix}sb${random_string.main.result}${local.workspace_suffix}"
  public_ip_rules                 = ["203.0.113.0/30"]
  virtual_network_subnet_ids      = module.network.subnet_id_list
  private_endpoint_name           = "${local.base_prefix}-pe-${local.workspace_suffix}"
  private_service_connection_name = "${local.base_prefix}-psc-${local.workspace_suffix}"
  key_vault_id                    = module.keyvault.key_vault_id
  key_vault_key_name              = module.keyvault.key_vault_key_name

  depends_on = [
    module.keyvault,
    module.network
  ]
}