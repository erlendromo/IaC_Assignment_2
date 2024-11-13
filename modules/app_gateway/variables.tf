# Resource Group variables

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The location/region."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
}



# Public IP variables

variable "pip_name" {
  type        = string
  description = "The name of the public IP."
}

variable "pip_allocation_method" {
  type        = string
  description = "The allocation method for the public IP."
  default     = "Static"
}

variable "pip_sku" {
  type        = string
  description = "The SKU for the public IP."
  default     = "Standard"
}



# Application Gateway variables

variable "application_gateway_name" {
  type        = string
  description = "The name of the application gateway."
}

variable "gateway_sku" {
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
  description = "The SKU for the application gateway."
  default = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
}

variable "gateway_ip_configuration" {
  type = object({
    name      = string
    subnet_id = string
  })
  description = "The IP configuration for the application gateway."
}

variable "gateway_frontend_port" {
  type = object({
    name = string
    port = number
  })
  description = "The frontend port for the application gateway."
  default = {
    name = "http"
    port = 80
  }
}

variable "gateway_frontend_ip_configuration_name" {
  type        = string
  description = "The frontend IP configuration name for the application gateway."
}

variable "gateway_backend_address_pool" {
  type = object({
    name  = string
    fqdns = list(string)
  })
  description = "The backend address pool for the application gateway."
}

variable "gateway_probe" {
  type = object({
    name                                      = string
    protocol                                  = string
    path                                      = string
    port                                      = number
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    pick_host_name_from_backend_http_settings = bool
    match = object({
      status_code = list(number)
    })
  })
  description = "The probe for the application gateway."
  default = {
    name                                      = "http-probe"
    protocol                                  = "Http"
    path                                      = "/"
    port                                      = 80
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
    match = {
      status_code = [200]
    }
  }
}

variable "gateway_backend_http_settings" {
  type = object({
    name                                = string
    protocol                            = string
    path                                = string
    port                                = number
    cookie_based_affinity               = string
    pick_host_name_from_backend_address = bool
    request_timeout                     = number
  })
  description = "The backend HTTP settings for the application gateway."
  default = {
    name                                = "appGatewayBackendHttpSettings"
    protocol                            = "Http"
    path                                = "/"
    port                                = 80
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    request_timeout                     = 20
  }
}

variable "gateway_http_listener" {
  type = object({
    name     = string
    protocol = string
  })
  description = "The HTTP listener for the application gateway."
  default = {
    name     = "appGatewayHttpListener"
    protocol = "Http"
  }
}

variable "gateway_request_routing_rule" {
  type = object({
    name      = string
    rule_type = string
    priority  = number
  })
  description = "The request routing rule for the application gateway."
  default = {
    name      = "http-rule"
    rule_type = "Basic"
    priority  = 100
  }
}