locals {
  subscription_id = "7c064ed9-c59f-4935-938b-f1a654d088a7"

  base_prefix      = "erlenrom"
  workspace_suffix = terraform.workspace == "default" ? "" : "-${terraform.workspace}"

  resource_group_name = "${local.base_prefix}-${var.resource_group_name}-${local.workspace_suffix}"
}