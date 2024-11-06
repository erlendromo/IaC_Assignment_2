resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = var.virtual_network_address_space
}

resource "azurerm_virtual_network_dns_servers" "main" {
  virtual_network_id = azurerm_virtual_network.main.id
  dns_servers        = var.dns_servers

  depends_on = [
    azurerm_virtual_network.main
  ]
}

resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = each.key
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
  resource_group_name  = azurerm_virtual_network.main.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name

  depends_on = [
    azurerm_virtual_network.main
  ]
}

resource "azurerm_network_security_group" "main" {
  name                = var.network_security_group_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_network_security_rule" "main" {
  for_each = var.network_security_rules

  name                       = each.key
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  resource_group_name         = azurerm_network_security_group.main.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name

  depends_on = [
    azurerm_network_security_group.main
  ]
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main.id

  depends_on = [
    azurerm_subnet.main,
    azurerm_network_security_group.main
  ]
}