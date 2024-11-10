output "app_gateway_public_ip" {
  value       = azurerm_public_ip.main.ip_address
  description = "The public IP address of the Application Gateway."
}