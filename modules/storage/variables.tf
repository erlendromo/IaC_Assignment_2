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
  type        = map(string)
  description = "A map of tags for the resources."
}


# Storage Account Variables

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
}

variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "account_kind" {
  type        = string
  description = "Defines the Kind to use for this storage account. Valid options are Storage, StorageV2, BlobStorage."
  default     = "StorageV2"
}

variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RA_GZRS."
  default     = "GRS"
}

variable "https_traffic_only_enabled" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled, and allows HTTP traffic if disabled."
  default     = true
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Boolean flag which allows public access to the content of any subdirectory, file or link in the storage account."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Boolean flag which allows public access to the storage account."
  default     = true
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "Boolean flag which enables shared access signature (SAS) tokens for all services in the storage account."
  default     = true
}

variable "local_user_enabled" {
  type        = bool
  description = "Boolean flag which enables the local user accounts."
  default     = false
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account. Valid values are TLS1_0, TLS1_1, and TLS1_2."
  default     = "TLS1_2"
}



# Storage Container Variables

variable "container_name" {
  type        = string
  description = "The name of the storage container."
  default     = "vhds"
}

variable "container_access_type" {
  type        = string
  description = "The access level to use for the storage container. Valid options are private, blob, container."
  default     = "private"
}