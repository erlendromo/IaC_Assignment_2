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
