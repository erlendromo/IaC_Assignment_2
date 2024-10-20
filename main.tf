resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location
}

module "network" {
  source                  = "./modules/network"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  virtual_network_name          = "vnet"
  virtual_network_address_space = [""]
  subnets = [
    {
      name             = "subnet1"
      address_prefixes = [""]
    },
    {
      name             = "subnet2"
      address_prefixes = [""]
    },
  ]
  dns_servers = [""]
}

output "subnet_id_map" {
  value = module.network.subnet_id_map
}