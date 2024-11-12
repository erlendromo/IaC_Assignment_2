# Resource Group Variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default     = "rg-backend-tfstate"
}

variable "location" {
  type        = string
  description = "The location of the resource group."
  default     = "norwayeast"
}



# Storage Variables

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
  default     = "sabackendtfstate"
}

variable "container_name" {
  type        = string
  description = "The name of the container."
  default     = "sc-backend-tfstate"
}



# Key Vault Variables

variable "keyvault_name" {
  type        = string
  description = "The name of the key vault."
  default     = "kvbackendtfstate"
}

variable "sa_backend_accesskey_name" {
  type        = string
  description = "The name of the storage account access key."
  default     = "sa-backend-accesskey"
}