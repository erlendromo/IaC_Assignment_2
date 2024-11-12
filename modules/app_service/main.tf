resource "azurerm_service_plan" "main" {
  name                   = var.service_plan_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  os_type                = var.os_type
  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  worker_count           = var.worker_count

  tags = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                = var.linux_web_app_name
  resource_group_name = azurerm_service_plan.main.resource_group_name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only                    = var.https_only
  client_certificate_enabled    = var.client_certificate_enabled
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = 25
        retention_in_mb   = 50
      }
    }
  }

  site_config {
    http2_enabled = true

    application_stack {
      go_version = var.go_version
    }
  }

  storage_account {
    name         = "webappstorage"
    type         = "AzureBlob"
    share_name   = var.storage_container_name
    account_name = var.storage_account_name
    access_key   = var.storage_account_access_key
  }

  tags = var.tags

  depends_on = [
    azurerm_service_plan.main
  ]
}

resource "azurerm_linux_web_app_slot" "main" {
  app_service_id                = azurerm_linux_web_app.main.id
  name                          = var.linux_web_app_slot_name
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    application_stack {
      go_version = var.go_version
    }
  }

  auth_settings {
    enabled = false
  }

  lifecycle {
    ignore_changes = [
      auth_settings
    ]
  }

  tags = var.tags

  depends_on = [
    azurerm_linux_web_app.main
  ]
}
