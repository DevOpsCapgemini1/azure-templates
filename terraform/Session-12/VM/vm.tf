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
variable "rgName" {
  type = string

}
variable "location" {
  type = string

}
variable "subnetName" {
  type = string
}
variable "vnetName" {
  type = string
}

resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = var.location
  resource_group_name = var.rgName
  allocation_method   = "Dynamic"
}
data "azurerm_subnet" "my_terraform_subnet" {
  name                 = var.subnetName
  virtual_network_name = var.vnetName
  resource_group_name  = var.rgName
}


resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = var.location
  resource_group_name = var.rgName

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = data.azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}
# variable "nsgName" {
#   type = string
# }
# data "azurerm_network_security_group" "example" {
#   name                = var.nsgName
#   resource_group_name = var.rgName
# }
# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.my_terraform_nic.id
#   network_security_group_id = data.azurerm_network_security_group.example.id
# }

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "vmSize" {
  type = string

}
variable "diskSize" {
  type = string

}
variable "vmName" {
  type = string

}
variable "vmImage" {
  type = map(any)
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = var.vmName
  location              = var.location
  resource_group_name   = var.rgName
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = var.vmSize

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.diskSize
  }

  source_image_reference {
    publisher = var.vmImage.publisher
    offer     = var.vmImage.offer
    sku       = var.vmImage.sku
    version   = var.vmImage.version
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }


}
