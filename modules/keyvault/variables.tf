# Key Vault variables

variable "resource_group_name" {
  type = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type = string
  description = "The location of the resource group."
}

variable "key_vault_name" {
  type = string
  description = "The name of the key vault."
}

variable "enabled_for_disk_encryption" {
  type = bool
  description = "Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default = true
}

variable "public_network_access_enabled" {
  type = bool
  description = "Specifies whether the key vault is accessible over the public network."
  default = false
}

variable "sku_name" {
  type = string
  description = "The SKU name of the key vault."
  default = "standard"
}

variable "soft_delete_retention_days" {
  type = number
  description = "The number of days that items should be retained for once soft deleted."
  default = 7
}

variable "purge_protection_enabled" {
  type = bool
  description = "Specifies whether protection against purge is enabled for this key vault."
  default = true
}

# User-assigned identity variables

variable "user_assigned_identity_tenant_id" {
  type = string
  description = "The tenant ID of the user assigned identity."
}

variable "user_assigned_identity_principal_id" {
  type = string
  description = "The principal ID of the user assigned identity."
}

# Key vault key variables

variable "key_vault_keys" {
  type = list(object({
    name     = string
    key_type = string
    key_size = number
    key_opts = list(string)
  }))
  description = "A list of key vault keys to create."
}