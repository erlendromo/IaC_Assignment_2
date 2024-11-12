# Resource Group Variables

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "rg-assignment2"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
  default     = "norwayeast"
}



# Network Variables

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
  default = "vnet"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "Address space of the virtual network"
  default = ["10.0.0.0/16"]
}

variable "subnets" {
  type        = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
  description = "Subnets of the virtual network"
  default = {
    "main-subnet" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = []
    },
    "app-subnet" = {
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  }
}



# Storage Variables

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
  default = "sa"
}



# Database Variables

variable "server_name" {
  type        = string
  description = "Name of the database server"
  default = "sqlserver"
}

variable "database_name" {
  type = string
  description = "Name of the database"
  default = "sqldb"
}

variable "mssql_administrator_login" {
  type        = string
  description = "Administrator login of the database server"  
}

variable "mssql_administrator_login_password" {
  type        = string
  description = "Administrator login password of the database server"
  sensitive = true
}


# App Service Variables

variable "service_plan_name" {
  type        = string
  description = "Name of the app service"
  default = "asp"
}

variable "linux_web_app_name" {
  type = string
  description = "Name of the Linux web app"
  default = "web"
}



# App Gateway Variables

variable "pip_name" {
  type = string
  description = "Name of the public IP"
  default = "appgw-pip"
}

variable "application_gateway_name" {
  type = string
  description = "Name of the application gateway"
  default = "appgw"
}

variable "gateway_ip_configuration_name" {
  type = string
  description = "Name of the gateway IP configuration"
  default = "appgwIPConfig"
}

variable "gateway_frontend_ip_configuration_name" {
  type = string
  description = "Name of the gateway frontend IP configuration"
  default = "appgwFrontendIPConfig"
}

variable "gateway_backend_address_pool_name" {
  type = string
  description = "Name of the gateway backend address pool"
  default = "appgwBackendAddressPool"
}