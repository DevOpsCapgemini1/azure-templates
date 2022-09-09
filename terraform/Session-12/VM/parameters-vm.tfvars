vmName = "myVMtf"
vmImage = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "latest"
}
vmSize     = "Standard_DS1_v2"
diskSize   = "Premium_LRS"
vnetName   = "myVnetTF"
subnetName = "SUBNET-0"
location   = "eastus"
rgName     = "tfeastus"
nsgName    = "myNsgName"
