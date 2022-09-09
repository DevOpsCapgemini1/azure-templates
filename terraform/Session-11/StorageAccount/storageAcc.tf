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

variable "storageAccountName" {
  type = string
}
variable "pricingTier" {
  type = map(string)
}
variable "resourceGroupName" {
  type = string
}

resource "azurerm_storage_account" "example" {
  name                     = var.storageAccountName
  resource_group_name      = var.resourceGroupName
  location                 = var.location
  account_tier             = var.pricingTier.account_tier
  account_replication_type = var.pricingTier.account_replication_type

}
