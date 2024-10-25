variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "base_prefix" {
  type        = string
  description = "The base prefix for the resource names."
}

variable "workspace_suffix" {
  type        = string
  description = "A suffix to append to the resource names."
}