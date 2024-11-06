# Virtual Network variables

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



# DNS variables

variable "dns_servers" {
  type        = list(string)
  description = "The DNS servers that are used by the virtual network."
  default = []
}



# Subnet variables

variable "subnets" {
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
  description = "The subnets that are used by the virtual network."
}


# Network Security Group variables

variable "network_security_group_name" {
  type        = string
  description = "The name of the network security group."

}



# Network Security Rule variables

variable "network_security_rules" {
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "The network security rules that are used by the network security group."
}