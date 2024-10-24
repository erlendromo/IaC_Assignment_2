module "network" {
  source                  = "../modules/network"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location

  virtual_network_name          = "${var.base_prefix}-vnet-${var.workspace_suffix}"
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
  source                      = "../modules/nsg"
  resource_group_name         = var.resource_group_name
  resource_group_location     = var.resource_group_location

  network_security_group_name = "${var.base_prefix}-nsg-${var.workspace_suffix}"
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