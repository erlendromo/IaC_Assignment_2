resource "azurerm_service_plan" "main" {
  name                   = var.service_plan_name
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  os_type                = var.os_type
  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  worker_count           = var.worker_count
}

resource "azurerm_linux_web_app" "main" {
  name                = var.linux_web_app_name
  resource_group_name = azurerm_service_plan.main.resource_group_name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only                    = var.https_only
  client_certificate_enabled    = var.client_certificate_enabled
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 25
        retention_in_mb   = 50
      }
    }
  }

  site_config {
    http2_enabled = true
    ftps_state    = "FtpsOnly"
    always_on     = true

    ip_restriction {
      ip_address  = var.subnet_cidr_range
      action      = "Allow"
      priority    = 100
      name        = "AllowSubnet"
      description = "Allow access from subnet"
    }

    application_stack {
      go_version = "1.19"
    }
  }

  storage_account {
    name         = "webappstorage"
    type         = "AzureFiles"
    share_name   = "webappstorage"
    account_name = var.storage_account_name
    access_key   = var.storage_account_access_key
  }

  depends_on = [
    azurerm_service_plan.main
  ]
}

resource "azurerm_linux_web_app_slot" "main" {
  app_service_id = azurerm_linux_web_app.main.id
  name           = "my_go_app"
  public_network_access_enabled = true

  site_config {
    application_stack {
      go_version = "1.19"
    }
  }

  auth_settings {
    enabled = false
  }
}

resource "azurerm_public_ip" "main" {
  name                = var.pip_name
  resource_group_name = azurerm_service_plan.main.resource_group_name
  location            = azurerm_service_plan.main.location
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_service_plan.main
  ]
}

resource "azurerm_application_gateway" "main" {
  name                = var.application_gateway_name
  resource_group_name = azurerm_service_plan.main.resource_group_name
  location            = azurerm_service_plan.main.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.application_gateway_subnet_id
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  backend_address_pool {
    name = "backendAddressPool"
    fqdns = [
      azurerm_linux_web_app.main.default_hostname
    ]
  }

  probe {
    name                                      = "httpProbe"
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true

    match {
      body        = ""
      status_code = [200]
    }
  }

  backend_http_settings {
    name                                = "appGatewayBackendHttpSettings"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 20
  }

  http_listener {
    name                           = "appGatewayHttpListener"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "appGatewayHttpListener"
    backend_address_pool_name  = "backendAddressPool"
    backend_http_settings_name = "appGatewayBackendHttpSettings"
    priority                   = 100
  }

  depends_on = [
    azurerm_service_plan.main,
    azurerm_linux_web_app.main,
    azurerm_public_ip.main
  ]
}
