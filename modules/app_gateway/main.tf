resource "azurerm_public_ip" "main" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku

  tags = var.tags
}

resource "azurerm_application_gateway" "main" {
  name                = var.application_gateway_name
  resource_group_name = azurerm_public_ip.main.resource_group_name
  location            = azurerm_public_ip.main.location

  sku {
    name     = var.gateway_sku.name
    tier     = var.gateway_sku.tier
    capacity = var.gateway_sku.capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration.name
    subnet_id = var.gateway_ip_configuration.subnet_id
  }

  frontend_port {
    name = var.gateway_frontend_port.name
    port = var.gateway_frontend_port.port
  }

  frontend_ip_configuration {
    name                 = var.gateway_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  backend_address_pool {
    name  = var.gateway_backend_address_pool.name
    fqdns = var.gateway_backend_address_pool.fqdns
  }

  probe {
    name                                      = var.gateway_probe.name
    protocol                                  = var.gateway_probe.protocol
    path                                      = var.gateway_probe.path
    port                                      = var.gateway_probe.port
    interval                                  = var.gateway_probe.interval
    timeout                                   = var.gateway_probe.timeout
    unhealthy_threshold                       = var.gateway_probe.unhealthy_threshold
    pick_host_name_from_backend_http_settings = var.gateway_probe.pick_host_name_from_backend_http_settings

    match {
      status_code = var.gateway_probe.match.status_code
    }
  }

  backend_http_settings {
    name                                = var.gateway_backend_http_settings.name
    protocol                            = var.gateway_backend_http_settings.protocol
    path                                = var.gateway_backend_http_settings.path
    port                                = var.gateway_backend_http_settings.port
    cookie_based_affinity               = var.gateway_backend_http_settings.cookie_based_affinity
    pick_host_name_from_backend_address = var.gateway_backend_http_settings.pick_host_name_from_backend_address
    request_timeout                     = var.gateway_backend_http_settings.request_timeout
  }

  http_listener {
    name                           = var.gateway_http_listener.name
    frontend_ip_configuration_name = var.gateway_frontend_ip_configuration_name
    frontend_port_name             = var.gateway_frontend_port.name
    protocol                       = var.gateway_http_listener.protocol
  }

  request_routing_rule {
    name                       = var.gateway_request_routing_rule.name
    rule_type                  = var.gateway_request_routing_rule.rule_type
    priority                   = var.gateway_request_routing_rule.priority
    http_listener_name         = var.gateway_http_listener.name
    backend_address_pool_name  = var.gateway_backend_address_pool.name
    backend_http_settings_name = var.gateway_backend_http_settings.name
  }

  tags = var.tags

  depends_on = [
    azurerm_public_ip.main
  ]
}
