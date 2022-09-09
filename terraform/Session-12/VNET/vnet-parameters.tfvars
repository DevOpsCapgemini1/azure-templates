location            = "eastus"
resource_group_name = "tfeastus"
address_space       = ["10.0.0.0/16"]
vnetName            = "myVnetTF"
subnet_prefix = {
  "0" = ["10.0.1.0/24"],
  "1" = ["10.0.2.0/24"]
}
