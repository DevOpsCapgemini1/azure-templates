terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {}
}
variable "resource_group_name" {
  type = string

}
variable "location" {
  type = string
}
resource "azurerm_web_application_firewall_policy" "example" {
  name                = "example-wafpolicy"
  resource_group_name = var.resource_group_name
  location            = var.location

  custom_rules {
    name      = "Rule1"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
    }

    action = "Block"
  }

  custom_rules {
    name      = "Rule2"
    priority  = 2
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24"]
    }

    match_conditions {
      match_variables {
        variable_name = "RequestHeaders"
        selector      = "UserAgent"
      }

      operator           = "Contains"
      negation_condition = false
      match_values       = ["Windows"]
    }

    action = "Block"
  }

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "x-company-secret-header"
      selector_match_operator = "Equals"
    }
    exclusion {
      match_variable          = "RequestCookieNames"
      selector                = "too-tasty"
      selector_match_operator = "EndsWith"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.1"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        disabled_rules = [
          "920300",
          "920440"
        ]
      }
    }
  }

}
data "azurerm_subnet" "example" {
  name                 = "SUBNET-1"
  virtual_network_name = "myVnetTF"
  resource_group_name  = var.resource_group_name
}
data "azurerm_public_ip" "test" {
  name                = "myPublicIP"
  resource_group_name = var.resource_group_name
}
variable "gatewayName" {
  type = string
}
variable "frontend_endpoints" {
  type = list(any)
}
variable "backend_address_pools" {
  type = list(any)
}
variable "frontend_ip_configuration_name" {
  type = string

}
variable "http_setting_name" {
  type = string

}
variable "http_listeners" {
  type = list(any)
}
variable "request_routing_rules" {
  type = list(any)
}
resource "azurerm_application_gateway" "network" {
  name                = var.gatewayName
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.example.id
  }

  dynamic "frontend_port" {
    for_each = toset(var.frontend_endpoints)
    content {
      name = lookup(frontend_port.value, "name", null)
      port = lookup(frontend_port.value, "port", null)
    }
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.test.id
  }
  dynamic "backend_address_pool" {
    for_each = toset(var.backend_address_pools)
    content {
      name         = lookup(backend_address_pool.value, "name", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }


  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  dynamic "http_listener" {
    for_each = toset(var.http_listeners)
    content {
      name                           = lookup(http_listener.value, "name", null)
      frontend_ip_configuration_name = var.frontend_ip_configuration_name
      frontend_port_name             = lookup(http_listener.value, "frontend_port_name", null)
      protocol                       = "Http"
    }
  }

  dynamic "request_routing_rule" {
    for_each = toset(var.request_routing_rules)
    content {
      name                       = lookup(request_routing_rule.value, "name", null)
      rule_type                  = "Basic"
      http_listener_name         = lookup(request_routing_rule.value, "http_listener_name", null)
      backend_address_pool_name  = lookup(request_routing_rule.value, "backend_address_pool_name", null)
      backend_http_settings_name = var.http_setting_name
    }
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.example.id

}
