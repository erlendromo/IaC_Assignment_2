locals {
  subscription_id = ""

  base_prefix      = "erlenrom"
  workspace_suffix = terraform.workspace == "default" ? "" : "-${terraform.workspace}"

  resource_group_name = "${local.base_prefix}-${var.resource_group_name}-${local.workspace_suffix}"
}