variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network."
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "subnets" {
  type = list(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
  description = "The subnets that are used by the virtual network."
}

variable "dns_servers" {
  type        = list(string)
  description = "The DNS servers that are used by the virtual network."
}
