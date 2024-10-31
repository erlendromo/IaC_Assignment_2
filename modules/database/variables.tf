# SQL server variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "server_name" {
  type        = string
  description = "The name of the SQL server."
}

variable "server_version" {
  type        = string
  description = "The version of the SQL server."
  default     = "12.0"
}

variable "administrator_login" {
  type        = string
  description = "The administrator login for the SQL server."
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator login password for the SQL server."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is enabled for the SQL server."
  default     = false
}

variable "minimum_tls_version" {
  type        = string
  description = "The minimum TLS version for the SQL server."
  default     = "1.2"
}



# Server Audit Policy variables

variable "retention_in_days" {
  type        = number
  description = "The retention in days for the server audit policy."
  default     = 90
}

variable "storage_account_access_key" {
  type        = string
  description = "The storage account access key for the server audit policy."
}

variable "storage_account_access_key_is_secondary" {
  type        = bool
  description = "Whether or not the storage account access key is secondary for the server audit policy."
  default     = false
}

variable "storage_endpoint" {
  type        = string
  description = "The storage endpoint for the server audit policy."
}



# SQL database variables

variable "database_name" {
  type        = string
  description = "The name of the SQL database."
}

variable "collation" {
  type        = string
  description = "The collation of the SQL database."
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  type        = string
  description = "The license type of the SQL database."
  default     = "LicenseIncluded"
}

variable "max_size_gb" {
  type        = number
  description = "The maximum size of the SQL database in gigabytes."
  default     = 1
}

variable "read_scale_enabled" {
  type        = bool
  description = "Whether or not read scale is enabled for the SQL database."
  default     = false
}

variable "sku_name" {
  type        = string
  description = "The SKU name of the SQL database."
  default     = "S0"
}

variable "zone_redundant" {
  type        = bool
  description = "Whether or not the SQL database is zone redundant."
  default     = false
}

variable "enclave_type" {
  type        = string
  description = "The enclave type of the SQL database."
  default     = "VBS"
}

variable "ledger_enabled" {
  type        = bool
  description = "Whether or not ledger is enabled for the SQL database."
  default     = true
}
