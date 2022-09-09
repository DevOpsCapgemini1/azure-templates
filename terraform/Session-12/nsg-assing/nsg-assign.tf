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
variable "subnetName" {
  type = string

}
variable "vnetName" {
  type = string

}
variable "nsgName" {
  type = string

}
variable "rgName" {
  type = string

}
data "azurerm_subnet" "example" {
  name                 = var.subnetName
  virtual_network_name = var.vnetName
  resource_group_name  = var.rgName
}
data "azurerm_network_security_group" "example" {
  name                = var.nsgName
  resource_group_name = var.rgName
}
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = data.azurerm_subnet.example.id
  network_security_group_id = data.azurerm_network_security_group.example.id
}
