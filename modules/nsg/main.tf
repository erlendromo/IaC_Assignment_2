resource "azurerm_network_security_group" "main" {
  name                = var.network_security_group_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
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
  for_each = var.subnet_id_map

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.main.id

  depends_on = [
    azurerm_subnet.main,
    azurerm_network_security_group.main
  ]
}