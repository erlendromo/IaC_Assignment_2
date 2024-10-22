output "web_app_hostname" {
  value       = module.app_service.linux_web_app_hostname
  description = "The hostname of the deployed web app"
}