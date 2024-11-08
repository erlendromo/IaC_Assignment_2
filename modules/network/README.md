# Network Module

The purpose of this module is to provision a VNET with proper DNS-servers and subnets. Connected to the VNET is a NSG with NSRs.

## Resources

- `azurerm_virtual_network`
- `azurerm_virtual_network_dns_servers`
- `azurerm_subnet`
- `azurerm_network_security_group`
- `azurerm_network_security_rule`
- `azurerm_subnet_network_security_group_association`

## Inputs (variables)

### Virtual Network Variables

- `resource_group_name` String
- `location` String
- `virtual_network_name` String
- `virtual_network_address_space` List(String)

### DNS Variables

- `dns_servers` List(String)

### Subnet Variables

- `subnets` Map(Object{
    `address_prefixes` List(String)
    `service_endpoints` List(String)
})

### NSG Variables

- `network_security_group_name` String

### NSR Variables

- `network_security_rules` Map(Object{
    `priority` Number
    `direction` String
    `access` String
    `protocol` String
    `source_port_range` String
    `destination_port_range` String
    `source_address_prefix` String
    `destination_address_prefix` String
})

## Outputs

- `subnet_id_map` Map(String)