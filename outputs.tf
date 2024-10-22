output "web_app_hostname" {
  value       = module.app_service.default_hostname
  description = "The hostname of the deployed web app"
}