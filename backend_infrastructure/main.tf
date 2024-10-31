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

# module "app_service" {
#   source                     = "../modules/app_service"
#   resource_group_name        = var.resource_group_name
#   resource_group_location    = var.resource_group_location
#   service_plan_name          = "${var.base_prefix}-sp-${var.workspace_suffix}"
#   linux_web_app_name         = "${var.base_prefix}-webapp-${var.workspace_suffix}"
#   storage_account_name       = module.storage.storage_account_name
#   storage_account_access_key = module.storage.storage_account_access_key

#   depends_on = [
#     module.storage
#   ]
# }

# resource "azurerm_public_ip" "main" {
#   name               = "${var.base_prefix}-pip-${var.workspace_suffix}"
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location
#   allocation_method   = "Static"
#   sku = "Standard"
# }

# resource "azurerm_lb" "main" {
#   name = "${var.base_prefix}-lb-${var.workspace_suffix}"
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location
#   sku = "Standard"

#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.main.id
#   }
# }

# resource "azurerm_lb_backend_address_pool" "main" {
#   name                = "${var.base_prefix}-bepool-${var.workspace_suffix}"
#   loadbalancer_id     = azurerm_lb.main.id
# }

# resource "azurerm_lb_probe" "main" {
#   name                = "${var.base_prefix}-probe-${var.workspace_suffix}"
#   loadbalancer_id     = azurerm_lb.main.id
#   protocol            = "https"
#   port                = 443
#   request_path        = "/"
# }

# resource "azurerm_lb_rule" "main" {
#   name                  = "${var.base_prefix}-lbrule-${var.workspace_suffix}"
#   loadbalancer_id       = azurerm_lb.main.id
#   frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
#   probe_id                     = azurerm_lb_probe.main.id
#   protocol                     = "Tcp"
#   frontend_port                = 80
#   backend_port                 = 80
# }

# resource "azurerm_network_interface" "main" {
#   name = "${var.base_prefix}-nic-${var.workspace_suffix}"
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = var.subnet_ids[0]
#     private_ip_address_allocation = "Dynamic"
#     gateway_load_balancer_frontend_ip_configuration_id = azurerm_lb.main.frontend_ip_configuration[0].id
#   }
# }
