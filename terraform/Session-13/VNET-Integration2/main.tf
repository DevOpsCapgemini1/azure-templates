
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
variable "appName" {
  type = string
}
data "azurerm_virtual_network" "vnet" {
  name = var.vnetName

  resource_group_name = var.resource_group_name

}
resource "azurerm_subnet" "example" {
  name                 = var.subnetName
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnetName
  address_prefixes     = ["10.0.0.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}
data "azurerm_linux_web_app" "example" {
  name                = var.appName
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id = data.azurerm_linux_web_app.example.id
  subnet_id      = azurerm_subnet.example.id
}
