output "sql_database_username" {
  value       = azurerm_mssql_server.main.administrator_login
  description = "The username for the SQL database"
  sensitive   = true
}

output "sql_database_password" {
  value       = azurerm_mssql_server.main.administrator_login_password
  description = "The password for the SQL database"
  sensitive   = true
}