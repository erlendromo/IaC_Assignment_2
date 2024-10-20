output "subnet_id_map" {
  value       = tomap(azurerm_subnet.main.*.name, azurerm_subnet.main.*.id)
  description = "Map of subnet names to subnet IDs"
}