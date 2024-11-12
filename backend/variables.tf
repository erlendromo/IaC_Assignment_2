# Resource Group Variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The location of the resource group."
}



# Storage Variables

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
}

variable "container_name" {
  type        = string
  description = "The name of the container."
}



# Key Vault Variables

variable "keyvault_name" {
  type        = string
  description = "The name of the key vault."
}

variable "sa_backend_accesskey_name" {
  type        = string
  description = "The name of the storage account access key."
}