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
variable "appConfName" {
  type = string
}
variable "webAppName" {
  type = string
}
variable "resource_group_name" {
  type = string
}
data "azurerm_app_configuration" "example" {
  name                = var.appConfName
  resource_group_name = var.resource_group_name
}
data "azurerm_linux_web_app" "example" {
  name                = var.webAppName
  resource_group_name = var.resource_group_name
}
resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_app_configuration.example.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = data.azurerm_linux_web_app.example.identity.0.principal_id
}
