data "azurerm_client_config" "current" {}

resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}

resource "random_password" "main" {
  length           = 16
  override_special = "!@#$%^&*()_+"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_user_assigned_identity" "main" {
  name                = "${local.base_prefix}-identity-${local.workspace_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}



module "core_infrastructure" {
  source                  = "./core_infrastructure"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  base_prefix             = local.base_prefix
  workspace_suffix        = local.workspace_suffix
}

module "backend_infrastructure" {
  source                     = "./backend_infrastructure"
  resource_group_name        = azurerm_resource_group.main.name
  resource_group_location    = azurerm_resource_group.main.location

  random_string              = random_string.main.result
  random_password            = random_password.main.result
  
  base_prefix                = local.base_prefix
  workspace_suffix           = local.workspace_suffix

  user_assigned_tenant_id    = azurerm_user_assigned_identity.main.tenant_id
  user_assigned_principal_id = azurerm_user_assigned_identity.main.principal_id

  subnet_ids                 = module.core_infrastructure.subnet_ids

  depends_on = [
    module.core_infrastructure,
    azurerm_user_assigned_identity.main
  ]
}



# module "app_service" {
#   source                     = "./modules/app_service"
#   resource_group_name        = azurerm_resource_group.main.name
#   resource_group_location    = azurerm_resource_group.main.location
#   service_plan_name          = "${local.base_prefix}-sp-${local.workspace_suffix}"
#   linux_web_app_name         = "${local.base_prefix}-webapp-${local.workspace_suffix}"
#   storage_account_name       = module.storage.storage_account_name
#   storage_account_access_key = module.storage.storage_account_access_key

#   depends_on = [module.storage]
# }

# resource "azurerm_lb" "main" {
#   name                = "${local.base_prefix}-lb-${local.workspace_suffix}"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   sku                 = "Basic"

#   frontend_ip_configuration {
#     name      = "EntryPoint"
#     subnet_id = module.network.subnet_id_list[0]
#   }

#   depends_on = [
#     module.network
#   ]
# }