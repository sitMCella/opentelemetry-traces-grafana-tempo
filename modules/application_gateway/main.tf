resource "azurerm_public_ip" "public_ip" {
  name                = "ip-agw-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = var.tags
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = "agw-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway_ip_configuration"
    subnet_id = var.application_gateway_subnet_id
  }

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  backend_address_pool {
    name         = "aks_load_balancer_backend"
    ip_addresses = ["10.0.0.4"]
  }

  backend_http_settings {
    name                                = "aks_grafana_backend_http_settings"
    port                                = 80
    protocol                            = "Http"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    probe_name                          = "aks_grafana_probe"
  }

  http_listener {
    name                           = "aks_http_listener"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "aks_routing_rule"
    rule_type                  = "Basic"
    http_listener_name         = "aks_http_listener"
    backend_address_pool_name  = "aks_load_balancer_backend"
    backend_http_settings_name = "aks_grafana_backend_http_settings"
    priority                   = 100
  }

  probe {
    name                                      = "aks_grafana_probe"
    pick_host_name_from_backend_http_settings = true
    interval                                  = 30
    protocol                                  = "Http"
    port                                      = 80
    path                                      = "/"
    timeout                                   = 60
    unhealthy_threshold                       = 5
    match {
      status_code = ["200-499"]
    }
  }

  tags = var.tags
}
