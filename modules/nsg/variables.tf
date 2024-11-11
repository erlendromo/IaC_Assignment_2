# Network Security Group variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The location of the resource group."
}

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



# Association variables

variable "subnet_id_map" {
  type        = map(string)
  description = "The IDs of the subnets that are associated with the network security group."
}
