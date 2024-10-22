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
      name              = "subnet-1"
      address_prefixes  = ["10.0.0.0/28"] # 16 ip addresses
      service_endpoints = []
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

module "app_service" {
  source                  = "./modules/app_service"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location
  service_plan_name       = "${local.base_prefix}-sp-${local.workspace_suffix}"
  os_type                 = "Linux"
  sku_name                = "P1v2"
  linux_web_app_name      = "${local.base_prefix}-webapp-${local.workspace_suffix}"
}

# resource "azurerm_public_ip" "main" {
#   name                = "${local.base_prefix}-pip-${local.workspace_suffix}"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   allocation_method   = "Static"
# }

resource "azurerm_lb" "main" {
  name                = "${local.base_prefix}-lb-${local.workspace_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"

  frontend_ip_configuration {
    name      = "EntryPoint"
    subnet_id = module.network.subnet_id_list[0]
  }
}