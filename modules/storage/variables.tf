variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "(Required) The location of the resource group."
}

variable "storage_account_name" {
  type        = string
  description = "(Required) The name of the storage account."
}

variable "storage_container_name" {
  type        = string
  description = "(Required) The name of the storage container."
}

variable "public_ip_rules" {
  type        = list(string)
  description = "(Required) The list of IP addresses that are allowed to access the storage account."
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "(Required) The list of virtual network subnet IDs that are allowed to access the storage account."
}

variable "private_endpoint_name" {
  type        = string
  description = "(Required) The name of the private endpoint."
}

variable "private_service_connection_name" {
  type        = string
  description = "(Required) The name of the private service connection."
}

variable "key_vault_id" {
  type        = string
  description = "(Required) The ID of the Key Vault."
}

variable "key_vault_key_name" {
  type        = string
  description = "(Required) The name of the key."
}

variable "storage_blob_name" {
  type        = string
  description = "(Required) The name of the storage blob."
}
