provider "azurerm" {
  subscription_id = local.subscription_id
  storage_use_azuread = true
  features {}
}

