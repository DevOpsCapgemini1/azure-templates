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


variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "address_space" {
  type = list(string)
}
variable "vnetName" {
  type = string
}
variable "subnet_prefix" {
  type = map(any)
}
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "example" {
  name                = var.vnetName
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.address_space


}


resource "azurerm_subnet" "example" {
  name                 = format("SUBNET-%s", count.index)
  count                = length(var.subnet_prefix)
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = lookup(var.subnet_prefix, count.index)
}
