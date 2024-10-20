resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = var.virtual_network_address_space
}

resource "azurerm_virtual_network_dns_servers" "main" {
  virtual_network_id = azurerm_virtual_network.main.id
  dns_servers        = var.dns_servers

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = each.key
  address_prefixes     = each.value.address_prefixes
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_network_security_group" "main" {
  name = "default"
  resource_group_name = azurerm_virtual_network.main.resource_group_name
  location = azurerm_virtual_network.main.location
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = azurerm_subnet.main

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.main.id
}