@description('Name of vnet')
param vnetName string
@description('Name of subnet')
param subnetName string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: '${vnetName}/${subnetName}'
}

module vnet_integration 'update-subnet.bicep' = {
  name: 'update-vnet-subnet-${vnetName}-${subnetName}'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    properties: union(subnet.properties, {
        serviceEndpoints: [
          {
            locations: [
              'uksouth'
            ]
            service: 'Microsoft.Sql'
          }
        ]
      })
  }
}
