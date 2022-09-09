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
variable "resource_group_name" {
  type = string

}
variable "location" {
  type = string
}
variable "appName" {
  type = string
}

variable "subnetName" {
  type = string
}
variable "virtual_network_name" {
  type = string
}

data "azurerm_linux_web_app" "example" {
  name                = var.appName
  resource_group_name = var.resource_group_name
}
data "azurerm_subnet" "example" {
  name                 = var.subnetName
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_private_endpoint" "privateendpoint" {
  name                = "backwebappprivateendpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.example.id


  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = data.azurerm_linux_web_app.example.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
