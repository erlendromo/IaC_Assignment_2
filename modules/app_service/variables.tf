# Service plan variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "service_plan_name" {
  type        = string
  description = "The name of the service plan."
}

variable "os_type" {
  type        = string
  description = "The operating system type of the service plan."
  default     = "Linux"
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the service plan."
  default     = "P1v2"
}

variable "zone_balancing_enabled" {
  type        = bool
  description = "Whether to enable zone balancing."
  default     = true
}

variable "worker_count" {
  type        = number
  description = "The number of workers."
  default     = 3
}

# Linux web app variables

variable "linux_web_app_name" {
  type        = string
  description = "The name of the Linux web app."
}

variable "https_only" {
  type        = bool
  description = "Whether to only allow HTTPS traffic."
  default     = true

}

variable "client_certificate_enabled" {
  type        = bool
  description = "Whether to enable client certificate authentication."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether to enable public network access."
  default     = false
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
}

variable "storage_account_access_key" {
  type        = string
  description = "The access key of the storage account."
}