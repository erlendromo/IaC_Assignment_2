terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "erlenrom-rg-backend-tfstate"
    storage_account_name = "erlenromsabackendtfstate"
    container_name       = "erlenrom-sc-backend-tfstate"
    key                  = "backend.terraform.tfstate"
  }
}
