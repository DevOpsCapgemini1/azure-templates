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
variable "keyVaultName" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "appName" {
  type = string
}
data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "example" {
  name                = var.keyVaultName
  resource_group_name = var.resource_group_name
}

data "azurerm_linux_web_app" "example" {
  name                = var.appName
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_access_policy" "myapp" {
  key_vault_id = data.azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id

  object_id = data.azurerm_linux_web_app.example.identity.0.principal_id

  secret_permissions = [
    "Get", "List"
  ]
}
