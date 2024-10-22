output "default_hostname" {
  value       = azurerm_linux_web_app.main.default_hostname
  description = "The default hostname of the Linux web app."
}