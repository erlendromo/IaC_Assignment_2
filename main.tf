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

  virtual_network_name          = "vnet"
  virtual_network_address_space = ["10.0.0.0/24"]                    # 256 ip addresses
  dns_servers                   = ["168.63.129.16", "168.63.129.17"] # Azure-provided DNS servers
  subnets = [
    {
      name             = "subnet-${random_string.main.result}"
      address_prefixes = ["10.0.0.0/28"] # 16 ip addresses
    }
  ]
}

module "nsg" {
  source                      = "./modules/nsg"
  resource_group_name         = azurerm_resource_group.main.name
  resource_group_location     = azurerm_resource_group.main.location
  network_security_group_name = "nsg"
  network_security_rules = {
    "https" = {
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

resource "azurerm_subnet_network_security_group_association" "subnet1" {
  subnet_id                 = module.network.subnet_id_list[0]
  network_security_group_id = module.nsg.network_security_group_id

  depends_on = [
    module.network,
    module.nsg
  ]
}
