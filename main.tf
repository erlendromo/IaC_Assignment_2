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



module "core_infrastructure" {
  source                  = "./core_infrastructure"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  base_prefix      = local.base_prefix
  workspace_suffix = local.workspace_suffix
}

module "backend_infrastructure" {
  source                  = "./backend_infrastructure"
  resource_group_name     = azurerm_resource_group.main.name
  resource_group_location = azurerm_resource_group.main.location

  random_string   = random_string.main.result
  random_password = random_password.main.result

  base_prefix      = local.base_prefix
  workspace_suffix = local.workspace_suffix

  subnet_ids = module.core_infrastructure.subnet_ids

  depends_on = [
    module.core_infrastructure
  ]
}
