resource "azurerm_service_plan" "main" {
  name                   = var.service_plan_name
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  os_type                = var.os_type
  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  worker_count           = var.worker_count
}

resource "azurerm_linux_web_app" "main" {
  name                          = var.linux_web_app_name
  resource_group_name           = azurerm_service_plan.main.resource_group_name
  location                      = azurerm_service_plan.main.location
  service_plan_id               = azurerm_service_plan.main.id
  https_only                    = var.https_only
  client_certificate_enabled    = var.client_certificate_enabled
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    http2_enabled                     = true
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 5
    minimum_tls_version               = "1.2"
    ftps_state                        = "FtpsOnly"
  }

  storage_account {
    name = "webappstorage"
    type = "AzureFiles"
    share_name = "webappstorage"
    account_name = var.storage_account_name
    access_key = var.storage_account_access_key
  }

  logs {
    failed_request_tracing  = true
    detailed_error_messages = true

    http_logs {
      file_system {
        retention_in_days = 25
        retention_in_mb   = 50
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled = true
  }
}