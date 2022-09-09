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

variable "servicePlanName" {
  type = string
}
variable "pricingTier" {
  type = string
}
variable "nodesInWebFarm" {
  type = number
}
variable "appName" {
  type = string
}
variable "dockerHubImage" {
  type = string
}
variable "resourceGroupName" {
  type = string
}


resource "azurerm_service_plan" "example" {
  name                = var.servicePlanName
  resource_group_name = var.resourceGroupName
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.pricingTier
  worker_count        = var.nodesInWebFarm
}
resource "azurerm_linux_web_app" "example" {
  name                = var.appName
  resource_group_name = var.resourceGroupName
  location            = var.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
    application_stack {
      docker_image     = var.dockerHubImage
      docker_image_tag = "latest"
    }
  }
}
