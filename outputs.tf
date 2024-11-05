output "database_username" {
  value       = module.backend_infrastructure.database_username
  description = "The username for the SQL database"
  sensitive   = true
}

output "database_password" {
  value       = module.backend_infrastructure.database_password
  description = "The password for the SQL database"
  sensitive   = true
}

output "webapp_public_ip" {
  value       = module.backend_infrastructure.webapp_public_ip
  description = "The public IP address of the web app"
}