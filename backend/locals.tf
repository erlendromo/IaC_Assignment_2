locals {
  subscription_id     = "7c064ed9-c59f-4935-938b-f1a654d088a7"
  base_prefix         = "erlenrom"
  resource_group_name = "${local.base_prefix}-${var.resource_group_name}"

  tags = {
    owner   = "erlenrom"
    project = "Assignment2"
    client  = "OperaTerra"
  }
}