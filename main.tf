resource "azurerm_resource_group" "main" {
  name = local.resource_group_name
  location = var.resource_group_location
}