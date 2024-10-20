output "network_security_group_id" {
  value       = azurerm_network_security_group.main.id
  description = "The ID of the Network Security Group"
}