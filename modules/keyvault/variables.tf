variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "(Required) Location of the resource group."
}

variable "key_vault_name" {
  type        = string
  description = "(Required) Name of the key vault."
}

variable "key_vault_key_name" {
  type        = string
  description = "(Required) Name of the key vault key."
}

variable "public_ip_rules" {
  type = list(string)
  description = "Public ip rules for the key vault."
}

variable "private_endpoint_name" {
  type        = string
  description = "(Required) Name of the private endpoint."
}

variable "subnet_id" {
  type        = string
  description = "(Required) ID of the subnet."
}

variable "private_service_connection_name" {
  type        = string
  description = "(Required) Name of the private service connection."
}