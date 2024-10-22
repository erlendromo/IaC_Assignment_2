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
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the service plan."
}

variable "linux_web_app_name" {
  type        = string
  description = "The name of the Linux web app."
}