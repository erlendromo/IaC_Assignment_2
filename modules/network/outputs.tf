output "subnet_id_map" {
  value       = tomap({ for subnet in azurerm_subnet.main : subnet.name => subnet.id })
  description = "Map of subnet names to subnet IDs"
}