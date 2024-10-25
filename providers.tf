provider "azurerm" {
  subscription_id     = local.subscription_id
  storage_use_azuread = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

