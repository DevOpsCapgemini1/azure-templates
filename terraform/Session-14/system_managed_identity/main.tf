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
variable "servicePlanName" {
  type = string
}
data "azurerm_app_service_plan" "example" {
  name                = var.servicePlanName
  resource_group_name = var.resource_group_name
}
resource "azurerm_linux_web_app" "example" {
  name                = var.appName
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = data.azurerm_app_service_plan.example.id
  identity {
    type = "SystemAssigned"
  }
  site_config {}
}
#/subscriptions/7d357068-33cb-4607-bb4d-02eaf5d20f25/resourceGroups/tfeastus/providers/Microsoft.Web/sites/myuniquelinuxwebapplication
