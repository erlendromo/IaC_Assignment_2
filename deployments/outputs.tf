output "database_username" {
  value       = module.database.sql_database_username
  description = "The username for the SQL database."
  sensitive   = true
}

output "database_password" {
  value       = module.database.sql_database_password
  description = "The password for the SQL database."
  sensitive   = true
}

output "webapp_public_ip" {
  value       = module.appgateway.app_gateway_public_ip
  description = "The public IP address of the application gateway."
}