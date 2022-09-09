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
variable "rules" {
  type = list(any)

}
variable "location" {
  type = string

}
variable "nsgName" {
  type = string
}
resource "azurerm_network_security_group" "example" {
  name                = var.nsgName
  resource_group_name = "tfeastus"
  location            = var.location
  dynamic "security_rule" {
    for_each = toset(var.rules)
    content {
      name                         = lookup(security_rule.value, "name", null)
      priority                     = lookup(security_rule.value, "priority", 1000)
      direction                    = lookup(security_rule.value, "direction", null)
      access                       = lookup(security_rule.value, "access", "Deny")
      protocol                     = lookup(security_rule.value, "protocol", "-1")
      source_port_range            = lookup(security_rule.value, "source_port_range", "*")
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", [])
      destination_port_range       = lookup(security_rule.value, "destination_port_range", "*")
      destination_port_ranges      = lookup(security_rule.value, "source_port_ranges", [])
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", "")
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", [])
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", "")
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", [])
    }
  }
}
