# Configure the Azure provider
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
variable "resourceGroupName" {
  type = string
}
variable "start_ip_address" {
  type = list(string)

}
variable "end_ip_address" {
  type = list(string)
}
variable "rule_number" {
  type = number
}
variable "location" {
  type = string
}
variable "sqlServerName" {
  type = string
}
variable "sqlDatabaseName" {
  type = string
}
variable "pricingTier" {
  type = string
}

resource "azurerm_sql_server" "example" {
  name                         = var.sqlServerName
  resource_group_name          = var.resourceGroupName
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"

}
resource "azurerm_sql_database" "example" {
  name                             = var.sqlDatabaseName
  resource_group_name              = var.resourceGroupName
  location                         = var.location
  server_name                      = azurerm_sql_server.example.name
  requested_service_objective_name = var.pricingTier

}


resource "azurerm_sql_firewall_rule" "main" {
  count = var.rule_number

  name                = "${azurerm_sql_server.example.name}-firewall-${count.index}"
  resource_group_name = var.resourceGroupName
  server_name         = azurerm_sql_server.example.name
  start_ip_address    = element(var.start_ip_address, count.index)
  end_ip_address      = element(var.end_ip_address, count.index)
}
