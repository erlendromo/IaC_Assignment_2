module "storage" {
  source                  = "../modules/storage"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location

  storage_account_name = "${var.base_prefix}sa${var.random_string}${var.workspace_suffix}"
}

module "sql_database" {
  source                       = "../modules/database"
  resource_group_name          = var.resource_group_name
  resource_group_location      = var.resource_group_location
  administrator_login          = var.random_string
  administrator_login_password = var.random_password

  server_name   = "${var.base_prefix}-sqlserver-${var.workspace_suffix}"
  database_name = "${var.base_prefix}-db-${var.workspace_suffix}"

  storage_account_access_key = module.storage.storage_account_access_key
  storage_endpoint           = module.storage.storage_blob_endpoint

  depends_on = [
    module.storage
  ]
}

module "app_service" {
  source                  = "../modules/app_service"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location

  service_plan_name  = "${var.base_prefix}-sp-${var.workspace_suffix}"
  linux_web_app_name = "${var.base_prefix}-webapp-${var.workspace_suffix}"

  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.storage_account_access_key

  depends_on = [
    module.storage
  ]
}

resource "azurerm_public_ip" "main" {
  name                = "${var.base_prefix}-pip-${var.workspace_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "main" {
  name                = "${var.base_prefix}-appgw-${var.workspace_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_ids[0]
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
    azurerm_linux_web_app.main,
    azurerm_public_ip.main
  ]
}