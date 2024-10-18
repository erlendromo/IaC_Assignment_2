terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "erlenrom-rg-backend-tfstate"
    storage_account_name = "sabackendtfstatefors050y"
    container_name       = "scbackendtfstate"
    key                  = "compulsory-assignment-2.terraform.tfstate"
  }
}