@description('The region in which the VNET will be created')
param location string

@description('Name of VNET')
param virtualNetworkName string
@description('VNET address space')
param addressSpace string
@description('Array of subnets')
param arrayOfSubnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: [for subnet in arrayOfSubnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}
