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

variable "appServicePlanName" {
  type = string
}
variable "resourceGroupName" {
  type = string
}
variable "appName" {
  type = string
}
variable "location" {
  type = string
}
variable "schedule" {
  type = map(any)
}
variable "storage_account_url" {
  type = string
}

data "azurerm_app_service_plan" "example" {
  name                = var.appServicePlanName
  resource_group_name = var.resourceGroupName
}
resource "azurerm_app_service" "myuniquelinuxwebapplication" {
  name                = var.appName
  location            = var.location
  resource_group_name = var.resourceGroupName
  app_service_plan_id = data.azurerm_app_service_plan.example.id
  connection_string {
    name  = "myConnectString"
    type  = "SQLServer"
    value = "Server=tcp:mssqlserverqwrrqwr.database.windows.net,1433;Initial Catalog=myexamplesqldatabaseqweqw;Persist Security Info=False;User ID=mradministrator;Password=thisIsDog11;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
  backup {
    name                = "MyBackupName"
    enabled             = true
    storage_account_url = var.storage_account_url
    schedule {
      frequency_interval       = var.schedule.frequency_interval
      frequency_unit           = var.schedule.frequency_unit
      keep_at_least_one_backup = var.schedule.keep_at_least_one_backup
      retention_period_in_days = var.schedule.retention_period_in_days
      start_time               = var.schedule.start_time
    }
  }
}

