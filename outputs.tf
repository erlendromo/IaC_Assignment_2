output "web_app_hostname" {
  value       = module.app_service.default_hostname
  description = "The hostname of the deployed web app"
}

output "sql_database_username" {
  value       = module.sql_database.sql_database_username
  description = "The username for the SQL database"
  sensitive   = true
}

output "sql_database_password" {
  value       = module.sql_database.sql_database_password
  description = "The password for the SQL database"
  sensitive   = true
}