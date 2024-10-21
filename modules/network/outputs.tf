output "subnet_id_list" {
  value       = tolist(azurerm_subnet.main.*.id)
  description = "List of subnet names to subnet IDs"
}