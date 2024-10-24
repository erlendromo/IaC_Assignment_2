# Storage Account Variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

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
  default     = false
}

variable "min_tls_version" {
  type = string
  description = "The minimum supported TLS version for the storage account. Valid values are TLS1_0, TLS1_1, and TLS1_2."
  default = "TLS1_2"
}

variable "virtual_network_subnet_ids" {
  type        = list(string)
  description = "A list of virtual network subnet ids to associate with the storage account."
}