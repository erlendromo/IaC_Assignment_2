# Resource Group Variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The location of the resource group."
}

variable "tags" {
  type = map(string)
  description = "A map of tags for the resources."
}



# Key Vault Variables

variable "keyvault_name" {
    type        = string
  description = "The name of the key vault."
}

variable "enabled_for_disk_encryption" {
    type        = bool
  description = "Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = true
}

variable "soft_delete_retention_days" {
    type        = number
  description = "The number of days that items should be retained for once soft deleted."
  default     = 7
}

variable "purge_protection_enabled" {
    type        = bool
  description = "Specifies whether to enable purge protection."
  default     = false
}

variable "sku_name" {
    type        = string
  description = "The Name of the SKU used for this Key Vault."
  default     = "standard"
}



# Key Vault Access Policy Variables

variable "key_permissions" {
    type        = list(string)
  description = "A list of key permissions to assign to the principal."
  default     = [
    "Get",
  "List",
  "Create",
  ]
}

variable "storage_permissions" {
    type        = list(string)
  description = "A list of storage permissions to assign to the principal."
  default     = [
    "Get",
  "List",
  "Set",
  ]
}

variable "secret_permissions" {
    type        = list(string)
  description = "A list of secret permissions to assign to the principal."
  default     = [
    "Get",
  "List",
  "Set",
  ]
}

variable "certificate_permissions" {
    type        = list(string)
  description = "A list of certificate permissions to assign to the principal."
  default     = []
}



# Key Vault Secret Variables

variable "sa_backend_accesskey_name" {
    type        = string
  description = "The name of the secret."
}

variable "sa_backend_accesskey" {
    type        = string
  description = "The value of the secret."
}