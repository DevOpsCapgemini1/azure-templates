
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}
provider "azurerm" {
  features {}
}
variable "vnetName" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnetName" {
  type = string
}
variable "sqlServerName" {
  type = string
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnetName
  resource_group_name = var.resource_group_name

}
resource "azurerm_subnet" "example" {
  name                 = var.subnetName
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnetName
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

}

resource "azurerm_sql_firewall_rule" "example" {
  name                = "FirewallRule1"
  resource_group_name = var.resource_group_name
  server_name         = var.sqlServerName
  start_ip_address    = "10.0.0.0"
  end_ip_address      = "10.0.0.0"
}
