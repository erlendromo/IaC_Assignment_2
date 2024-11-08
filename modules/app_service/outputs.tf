output "webapp_public_ip" {
  value       = azurerm_public_ip.main.ip_address
  description = "The public IP address of the web app"
}

// TODO change this to gateway outbound IP