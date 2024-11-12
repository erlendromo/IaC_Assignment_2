locals {
  subscription_id = "7c064ed9-c59f-4935-938b-f1a654d088a7"
  base_prefix      = "erlenrom"
  workspace_suffix = terraform.workspace == "default" ? "" : "${terraform.workspace}"

  resource_group_name = "${local.base_prefix}-${var.resource_group_name}-${local.workspace_suffix}"
  virtual_network_name = "${local.base_prefix}-${var.virtual_network_name}-${local.workspace_suffix}"
  storage_account_name = "${local.base_prefix}${var.storage_account_name}${random_string.main.result}${local.workspace_suffix}"
  server_name = "${local.base_prefix}-${var.server_name}-${local.workspace_suffix}"
  database_name = "${local.base_prefix}-${var.database_name}-${local.workspace_suffix}"
  service_plan_name = "${local.base_prefix}-${var.service_plan_name}-${local.workspace_suffix}"
  linux_web_app_name = "${local.base_prefix}-${var.linux_web_app_name}-${local.workspace_suffix}"
  pip_name = "${local.base_prefix}-${var.pip_name}-${local.workspace_suffix}"
  application_gateway_name = "${local.base_prefix}-${var.application_gateway_name}-${local.workspace_suffix}"

  tags = {
    owner       = "erlenrom"
    project     = "Assignment2"
    client      = "OperaTerra"
    environment = terraform.workspace
  }
}