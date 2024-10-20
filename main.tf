resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location
}

module "network" {
  source                  = "./modules/network"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  virtual_network_name          = "vnet"
  virtual_network_address_space = [ "10.0.0.0/24" ] # 256 ip addresses
  dns_servers = ["168.63.129.16", "168.63.129.17"] # Azure-provided DNS servers
  subnets = [
    {
      name             = "subnet1"
      address_prefixes = ["10.0.0.0/28"] # 16 ip addresses
    },
    {
      name             = "subnet2"
      address_prefixes = ["10.0.0.16/28"] # 16 ip addresses
    },
  ]
}

output "subnet_id_map" {
  value = module.network.subnet_id_map
}