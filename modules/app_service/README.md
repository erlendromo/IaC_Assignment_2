# App-Service Module

The purpose of this module is to setup a service-plan, with a linux-web-app attached to it.
A gateway (load-balancer) is connected to the the web-app between a public ip, and a subnet id sent to the module.

## Resources

- `azurerm_service_plan`
- `azurerm_linux_web_app`
- `azurerm_public_ip`
- `azurerm_application_gateway`

## Inputs (variables)

### Service Plan Variables

- `resource_group_name` String
- `location` String
- `service_plan_name` String
- `os_type` String
- `sku_name` String
- `zone_balancing_enabled` Boolean
- `worker_count` Number

### Linux Web App Variables

- `linux_webapp_name` String
- `https_only` Boolean
- `client_certificate_enabled` Boolean
- `public_network_access_enabled` Boolean
- `subnet_cidr_range` String
- `storage_account_name` String
- `storage_account_access_key` String

### Public IP Variables

- `pip_name` String

### Application Gateway Variables

- `application_gateway_name` String
- `application_gateway_subnet_id` String

## Outputs

- `webapp_public_ip` String (CHANGE THIS TO GATEWAY OUTBOUND IP)