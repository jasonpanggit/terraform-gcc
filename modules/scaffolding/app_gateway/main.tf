resource "azurerm_public_ip" "app_gateway_public_ips" {
  for_each            = var.app_gateway_public_ips
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  allocation_method = each.value.allocation_method
  sku               = each.value.sku
}

resource "azurerm_application_gateway" "app_gateways" {
  for_each            = var.app_gateways
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.sku_capacity
  }

  gateway_ip_configuration {
    name      = each.value.gw_ip_config_name
    subnet_id = var.subnets[each.value.subnet_key].id
  }

  frontend_port {
    name = each.value.frontend_port_name
    port = each.value.frontend_port
  }

  frontend_ip_configuration {
    name                 = each.value.frontend_public_ip_config_name
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ips[each.value.public_ip_key].id
  }

  frontend_ip_configuration {
    name                          = each.value.frontend_private_ip_config_name
    subnet_id                     = var.subnets[each.value.subnet_key].id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.frontend_private_ip_config_private_ip_address
  }

  backend_address_pool {
    name = each.value.backend_address_pool_name
  }

  backend_http_settings {
    name                  = each.value.backend_http_settings_name
    cookie_based_affinity = each.value.backend_http_settings_cookie_based_affinity
    path                  = each.value.backend_http_settings_path
    port                  = each.value.backend_http_settings_port
    protocol              = each.value.backend_http_settings_protocol
    request_timeout       = each.value.backend_http_settings_request_timeout
  }

  http_listener {
    name                           = each.value.http_listener_name
    frontend_ip_configuration_name = each.value.frontend_private_ip_config_name
    frontend_port_name             = each.value.frontend_port_name
    protocol                       = each.value.http_listener_protocol
  }

  request_routing_rule {
    name                       = each.value.request_routing_rule_name
    priority                   = each.value.request_routing_rule_priority
    rule_type                  = each.value.request_routing_rule_type
    http_listener_name         = each.value.http_listener_name
    backend_address_pool_name  = each.value.backend_address_pool_name
    backend_http_settings_name = each.value.backend_http_settings_name
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}