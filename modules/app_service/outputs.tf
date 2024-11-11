output "web_app_slot_hostname" {
  value       = azurerm_linux_web_app_slot.main.default_hostname
  description = "The hostname of the web app slot"
  sensitive   = true
}