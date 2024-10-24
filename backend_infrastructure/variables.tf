variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "random_string" {
  type        = string
  description = "Random generated string."
}

variable "random_password" {
  type        = string
  description = "Random generated password."
}

variable "base_prefix" {
  type        = string
  description = "The base prefix for the naming convention."
}

variable "workspace_suffix" {
  type        = string
  description = "The suffix to append to the workspace name."
}

variable "user_assigned_tenant_id" {
  type        = string
  description = "The tenant ID of the user assigned identity."
}

variable "user_assigned_principal_id" {
  type        = string
  description = "The principal ID of the user assigned identity."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs."
}