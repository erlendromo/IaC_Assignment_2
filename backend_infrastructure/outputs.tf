output "database_username" {
  value       = module.sql_database.sql_database_username
  description = "The username for the SQL database"
  sensitive   = true
}

output "database_password" {
  value       = module.sql_database.sql_database_password
  description = "The password for the SQL database"
  sensitive   = true
}

output "webapp_public_ip" {
  value       = azurerm_public_ip.main.ip_address
  description = "The public IP address of the web app"
}